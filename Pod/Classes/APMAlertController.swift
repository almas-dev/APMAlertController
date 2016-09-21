//
// Created by Alexander Maslennikov on 09.11.15.
//

import UIKit
import SnapKit

@objc public enum APMAlertControllerStyle: Int {
    case alert
    case actionSheet
}

@objc open class APMAlertController: UIViewController {
    fileprivate let verticalAlertIndent: CGFloat = 25

    open var buttonTitleColor: UIColor?
    open var customButtonFont: UIFont?
    open var buttonBackgroundColor: UIColor?
    open var customDescriptionFont: UIFont?
    open var disableImageIconTemplate: Bool = false
    open var separatorColor = UIColor(white: 0.75, alpha: 0.6)
    open var showTitleMessageSeparator: Bool = false
    open var tintColor: UIColor = UIColor.black
    open let messageContentView: UIView = UIView()

    let alertView = UIView()
    fileprivate let topScrollView = UIScrollView()
    fileprivate var topScrollViewHeightConstraint: Constraint?
    fileprivate let contentView = UIView()
    fileprivate var anyTitleObject: AnyObject
    fileprivate var topTitleMessageSeparatorConstraint: Constraint?
    fileprivate let titleMessageSeparator = UIView()
    fileprivate var messageLabel: UILabel?
    fileprivate let buttonsView = UIView()
    fileprivate let button = UIButton()
    fileprivate var alertTitle: String?
    fileprivate var alertTitleImage: UIImage?
    fileprivate var alertMessage: String?
    fileprivate var alertAttributedMessage: NSAttributedString?
    fileprivate var actions = [APMAlertActionProtocol]()
    fileprivate var buttons: [UIButton] = [] {
        didSet {
            buttonsView.removeConstraints(buttonsView.constraints)
            for (index, value) in buttons.enumerated() {
                value.setTitleColor(buttonTitleColor ?? tintColor, for: UIControlState())
                value.setTitleColor(buttonTitleColor ?? tintColor.withAlphaComponent(0.33), for: .highlighted)
                value.setTitleColor(buttonTitleColor ?? tintColor.withAlphaComponent(0.33), for: .selected)

                if let backgroundColor = buttonBackgroundColor {
                    value.backgroundColor = backgroundColor
                }


                let top = NSLayoutConstraint(item: value, attribute: .top, relatedBy: .equal, toItem: buttonsView, attribute: .top, multiplier: 1.0, constant: 1)
                let bottom = NSLayoutConstraint(item: value, attribute: .bottom, relatedBy: .equal, toItem: buttonsView, attribute: .bottom, multiplier: 1.0, constant: 0)

                let left: NSLayoutConstraint
                let right = NSLayoutConstraint(item: value, attribute: .right, relatedBy: .equal, toItem: buttonsView, attribute: .right, multiplier: 1.0, constant: 0)
                if index == 0 {
                    left = NSLayoutConstraint(item: value, attribute: .left, relatedBy: .equal, toItem: buttonsView, attribute: .left, multiplier: 1.0, constant: 0)
                    if buttons.count == 1 {
                        buttonsView.addConstraints([top, left, right, bottom])
                    } else {
                        buttonsView.addConstraints([top, left, bottom])
                    }
                } else {
                    let previousButton = buttons[index - 1]
                    left = NSLayoutConstraint(item: value, attribute: .left, relatedBy: .equal, toItem: previousButton, attribute: .right, multiplier: 1.0, constant: 1)
                    let width = NSLayoutConstraint(item: value, attribute: .width, relatedBy: .equal, toItem: previousButton, attribute: .width, multiplier: 1.0, constant: 0)
                    if index == buttons.count - 1 {
                        buttonsView.addConstraints([top, left, right, bottom, width])
                    } else {
                        buttonsView.addConstraints([top, left, bottom, width])
                    }
                }
            }
        }
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    public init(titleObject: AnyObject) {
        self.anyTitleObject = titleObject
        super.init(nibName: nil, bundle: nil)

        self.modalPresentationStyle = UIModalPresentationStyle.custom
        self.transitioningDelegate = self
    }

    public convenience init(title: String?, message: String?, preferredStyle: APMAlertControllerStyle) {
        self.init(titleObject: UILabel())
        self.alertTitle = title
        self.alertMessage = message
    }

    public convenience init(title: String?, attributedMessage: NSAttributedString?, preferredStyle: APMAlertControllerStyle) {
        self.init(titleObject: UILabel())
        self.alertTitle = title
        self.alertAttributedMessage = attributedMessage
    }

    public convenience init(titleImage: UIImage?, message: String?, preferredStyle: APMAlertControllerStyle) {
        self.init(titleObject: UIImageView())
        self.alertTitleImage = titleImage
        self.alertMessage = message
    }

    public convenience init(title: String?, preferredStyle: APMAlertControllerStyle) {
        self.init(titleObject: UILabel())
        self.alertTitle = title
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureLayout()
    }

    func configureView() {
        alertView.backgroundColor = UIColor(white: 1, alpha: 0.95)
        alertView.layer.cornerRadius = 12
        alertView.clipsToBounds = true
        view.addSubview(alertView)

        alertView.addSubview(topScrollView)

        configureTopScrollView()

        buttonsView.backgroundColor = separatorColor
        alertView.addSubview(buttonsView)
    }

    func configureTopScrollView() {
        topScrollView.addSubview(contentView)

        switch anyTitleObject {
        case let titleImageView as UIImageView:
            titleImageView.contentMode = .scaleAspectFit
            titleImageView.image = disableImageIconTemplate ? alertTitleImage : alertTitleImage?.withRenderingMode(.alwaysTemplate)
            titleImageView.alpha = 0.8
            contentView.addSubview(titleImageView)
        case let titleLabel as UILabel:
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            titleLabel.text = alertTitle
            contentView.addSubview(titleLabel)
        default:
            break
        }

        titleMessageSeparator.backgroundColor = separatorColor
        titleMessageSeparator.isHidden = true
        contentView.addSubview(titleMessageSeparator)

        contentView.addSubview(messageContentView)

        if alertMessage != nil || alertAttributedMessage != nil {
            let messageLabel = UILabel()

            messageLabel.font = self.customDescriptionFont ?? UIFont.systemFont(ofSize: 16)
            messageLabel.textAlignment = .center
            if let alertMessage = self.alertMessage {
                messageLabel.text = alertMessage
            } else if let alertAttributedMessage = self.alertAttributedMessage {
                messageLabel.attributedText = alertAttributedMessage
            }
            messageLabel.numberOfLines = 0
            messageContentView.addSubview(messageLabel)

            self.messageLabel = messageLabel
        }
    }

    func configureLayout() {
        alertView.snp.makeConstraints {
            $0.center.equalTo(view)
            $0.width.equalTo(270)
            $0.height.lessThanOrEqualTo(view).offset(-(verticalAlertIndent * 2))
        }

        topScrollView.snp.makeConstraints {
            $0.top.equalTo(alertView)
            $0.left.equalTo(alertView)
            $0.right.equalTo(alertView)
            topScrollViewHeightConstraint = $0.height.equalTo(0).constraint
        }

        configureTopScrollViewLayout()

        buttonsView.snp.makeConstraints {
            $0.top.equalTo(topScrollView.snp.bottom)
            $0.left.equalTo(alertView)
            $0.right.equalTo(alertView)
            $0.bottom.equalTo(alertView)
            $0.height.equalTo(45)
        }
    }

    func configureTopScrollViewLayout() {
        contentView.snp.makeConstraints {
            $0.edges.equalTo(topScrollView)
            $0.width.equalTo(topScrollView)
        }

        (anyTitleObject as! UIView).snp.makeConstraints {
            $0.top.equalTo(contentView).offset(20)
            $0.left.equalTo(contentView).offset(30)
            $0.right.equalTo(contentView).offset(-30)
        }

        titleMessageSeparator.snp.makeConstraints {
            topTitleMessageSeparatorConstraint = $0.top.equalTo((anyTitleObject as! UIView).snp.bottom).constraint
            $0.left.equalTo(contentView)
            $0.right.equalTo(contentView)
            $0.height.equalTo(1)
        }

        messageContentView.snp.makeConstraints {
            $0.top.equalTo(titleMessageSeparator.snp.bottom)
            $0.left.equalTo(contentView)
            $0.right.equalTo(contentView)
            $0.bottom.equalTo(contentView)
        }

        if let messageLabel = self.messageLabel {
            messageLabel.snp.makeConstraints {
                $0.top.equalTo(messageContentView).offset(12)
                $0.left.equalTo(messageContentView).offset(30)
                $0.bottom.equalTo(messageContentView).offset(-16)
                $0.right.equalTo(messageContentView).offset(-30)
            }
        }
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        topScrollView.updateConstraintsIfNeeded()
        topScrollView.contentSize = contentView.frame.size
        if view.frame.size.height - verticalAlertIndent * 2 - 45 >= contentView.frame.size.height {
            topScrollViewHeightConstraint?.update(offset: contentView.frame.size.height)
        } else {
            topScrollViewHeightConstraint?.update(offset: view.frame.size.height - verticalAlertIndent * 2 - 45)
        }

        titleMessageSeparator.isHidden = !showTitleMessageSeparator
        topTitleMessageSeparatorConstraint?.update(offset: showTitleMessageSeparator || (alertMessage == nil && alertAttributedMessage == nil) ? 14 : 0)

        switch anyTitleObject {
        case let titleImageView as UIImageView:
            titleImageView.tintColor = tintColor
        case let titleLabel as UILabel:
            titleLabel.textColor = tintColor
        default:
            break
        }
        if let messageLabel = self.messageLabel , alertAttributedMessage == nil {
            messageLabel.textColor = tintColor
        }
    }

    open func addAction(_ action: APMAlertActionProtocol) {
        actions.append(action)

        let button = UIButton()
        if let buttonFont = self.customButtonFont {
            button.titleLabel?.font = buttonFont
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.setTitle(action.title, for: UIControlState())
        button.setTitleColor(UIColor.lightGray, for: .selected)
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
        button.addTarget(self, action: #selector(btnPressed(_:)), for: .touchUpInside)
        button.tag = buttons.count + 1
        button.backgroundColor = UIColor.white
        buttonsView.addSubview(button)
        buttons.append(button)
    }

    func btnPressed(_ button: UIButton) {
        button.isSelected = true
        self.dismiss(animated: true, completion: {
            let action = self.actions[button.tag - 1]
            action.handler?(action)
        })
    }
}

extension APMAlertController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return APMAlertAnimation(presenting: true)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return APMAlertAnimation(presenting: false)
    }
}
