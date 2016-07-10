//
// Created by Alexander Maslennikov on 09.11.15.
//

import UIKit
import SnapKit

@objc public enum APMAlertControllerStyle: Int {
    case Alert
    case ActionSheet
}

@objc public class APMAlertController: UIViewController {
    private let verticalAlertIndent: CGFloat = 25

    public var buttonTitleColor: UIColor?
    public var customButtonFont: UIFont?
    public var buttonBackgroundColor: UIColor?
    public var customDescriptionFont: UIFont?
    public var disableImageIconTemplate: Bool = false
    public var separatorColor = UIColor(white: 0.75, alpha: 0.6)
    public var showTitleMessageSeparator: Bool = false
    public var tintColor: UIColor = UIColor.blackColor()
    public let messageContentView: UIView = UIView()

    let alertView = UIView()
    private let topScrollView = UIScrollView()
    private var topScrollViewHeightConstraint: Constraint?
    private let contentView = UIView()
    private var anyTitleObject: AnyObject
    private var topTitleMessageSeparatorConstraint: Constraint?
    private let titleMessageSeparator = UIView()
    private var messageLabel: UILabel?
    private let buttonsView = UIView()
    private let button = UIButton()
    private var alertTitle: String?
    private var alertTitleImage: UIImage?
    private var alertMessage: String?
    private var alertAttributedMessage: NSAttributedString?
    private var actions = [APMAlertActionProtocol]()
    private var buttons: [UIButton] = [] {
        didSet {
            buttonsView.removeConstraints(buttonsView.constraints)
            for (index, value) in buttons.enumerate() {
                value.setTitleColor(buttonTitleColor ?? tintColor, forState: .Normal)
                value.setTitleColor(buttonTitleColor ?? tintColor.colorWithAlphaComponent(0.33), forState: .Highlighted)
                value.setTitleColor(buttonTitleColor ?? tintColor.colorWithAlphaComponent(0.33), forState: .Selected)

                if let backgroundColor = buttonBackgroundColor {
                    value.backgroundColor = backgroundColor
                }


                let top = NSLayoutConstraint(item: value, attribute: .Top, relatedBy: .Equal, toItem: buttonsView, attribute: .Top, multiplier: 1.0, constant: 1)
                let bottom = NSLayoutConstraint(item: value, attribute: .Bottom, relatedBy: .Equal, toItem: buttonsView, attribute: .Bottom, multiplier: 1.0, constant: 0)

                let left: NSLayoutConstraint
                let right = NSLayoutConstraint(item: value, attribute: .Right, relatedBy: .Equal, toItem: buttonsView, attribute: .Right, multiplier: 1.0, constant: 0)
                if index == 0 {
                    left = NSLayoutConstraint(item: value, attribute: .Left, relatedBy: .Equal, toItem: buttonsView, attribute: .Left, multiplier: 1.0, constant: 0)
                    if buttons.count == 1 {
                        buttonsView.addConstraints([top, left, right, bottom])
                    } else {
                        buttonsView.addConstraints([top, left, bottom])
                    }
                } else {
                    let previousButton = buttons[index - 1]
                    left = NSLayoutConstraint(item: value, attribute: .Left, relatedBy: .Equal, toItem: previousButton, attribute: .Right, multiplier: 1.0, constant: 1)
                    let width = NSLayoutConstraint(item: value, attribute: .Width, relatedBy: .Equal, toItem: previousButton, attribute: .Width, multiplier: 1.0, constant: 0)
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

        self.modalPresentationStyle = UIModalPresentationStyle.Custom
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

    public override func viewDidLoad() {
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
            titleImageView.contentMode = .ScaleAspectFit
            titleImageView.image = disableImageIconTemplate ? alertTitleImage : alertTitleImage?.imageWithRenderingMode(.AlwaysTemplate)
            titleImageView.alpha = 0.8
            contentView.addSubview(titleImageView)
        case let titleLabel as UILabel:
            titleLabel.font = UIFont.boldSystemFontOfSize(16)
            titleLabel.textAlignment = .Center
            titleLabel.numberOfLines = 0
            titleLabel.text = alertTitle
            contentView.addSubview(titleLabel)
        default:
            break
        }

        titleMessageSeparator.backgroundColor = separatorColor
        titleMessageSeparator.hidden = true
        contentView.addSubview(titleMessageSeparator)

        contentView.addSubview(messageContentView)

        if alertMessage != nil || alertAttributedMessage != nil {
            let messageLabel = UILabel()

            messageLabel.font = self.customDescriptionFont ?? UIFont.systemFontOfSize(16)
            messageLabel.textAlignment = .Center
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
        alertView.snp_makeConstraints {
            $0.center.equalTo(view)
            $0.width.equalTo(270)
            $0.height.lessThanOrEqualTo(view).offset(-(verticalAlertIndent * 2))
        }

        topScrollView.snp_makeConstraints {
            $0.top.equalTo(alertView)
            $0.left.equalTo(alertView)
            $0.right.equalTo(alertView)
            topScrollViewHeightConstraint = $0.height.equalTo(0).constraint
        }

        configureTopScrollViewLayout()

        buttonsView.snp_makeConstraints {
            $0.top.equalTo(topScrollView.snp_bottom)
            $0.left.equalTo(alertView)
            $0.right.equalTo(alertView)
            $0.bottom.equalTo(alertView)
            $0.height.equalTo(45)
        }
    }

    func configureTopScrollViewLayout() {
        contentView.snp_makeConstraints {
            $0.edges.equalTo(topScrollView)
            $0.width.equalTo(topScrollView)
        }

        (anyTitleObject as! UIView).snp_makeConstraints {
            $0.top.equalTo(contentView).offset(20)
            $0.left.equalTo(contentView).offset(30)
            $0.right.equalTo(contentView).offset(-30)
        }

        titleMessageSeparator.snp_makeConstraints {
            topTitleMessageSeparatorConstraint = $0.top.equalTo((anyTitleObject as! UIView).snp_bottom).constraint
            $0.left.equalTo(contentView)
            $0.right.equalTo(contentView)
            $0.height.equalTo(1)
        }

        messageContentView.snp_makeConstraints {
            $0.top.equalTo(titleMessageSeparator.snp_bottom)
            $0.left.equalTo(contentView)
            $0.right.equalTo(contentView)
            $0.bottom.equalTo(contentView)
        }

        if let messageLabel = self.messageLabel {
            messageLabel.snp_makeConstraints {
                $0.edges.equalTo(messageContentView).offset(UIEdgeInsetsMake(12, 30, -16, -30))
            }
        }
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        topScrollView.updateConstraintsIfNeeded()
        topScrollView.contentSize = contentView.frame.size
        if view.frame.size.height - verticalAlertIndent * 2 - 45 >= contentView.frame.size.height {
            topScrollViewHeightConstraint?.updateOffset(contentView.frame.size.height)
        } else {
            topScrollViewHeightConstraint?.updateOffset(view.frame.size.height - verticalAlertIndent * 2 - 45)
        }

        titleMessageSeparator.hidden = !showTitleMessageSeparator
        topTitleMessageSeparatorConstraint?.updateOffset(showTitleMessageSeparator || (alertMessage == nil && alertAttributedMessage == nil) ? 14 : 0)

        switch anyTitleObject {
        case let titleImageView as UIImageView:
            titleImageView.tintColor = tintColor
        case let titleLabel as UILabel:
            titleLabel.textColor = tintColor
        default:
            break
        }
        if let messageLabel = self.messageLabel where alertAttributedMessage == nil {
            messageLabel.textColor = tintColor
        }
    }

    public func addAction(action: APMAlertActionProtocol) {
        actions.append(action)

        let button = UIButton()
        if let buttonFont = self.customButtonFont {
            button.titleLabel?.font = buttonFont
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.setTitle(action.title, forState: .Normal)
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Selected)
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        button.addTarget(self, action: #selector(btnPressed(_:)), forControlEvents: .TouchUpInside)
        button.tag = buttons.count + 1
        button.backgroundColor = UIColor.whiteColor()
        buttonsView.addSubview(button)
        buttons.append(button)
    }

    func btnPressed(button: UIButton) {
        button.selected = true
        self.dismissViewControllerAnimated(true, completion: {
            let action = self.actions[button.tag - 1]
            action.handler?(action)
        })
    }
}

extension APMAlertController: UIViewControllerTransitioningDelegate {
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return APMAlertAnimation(presenting: true)
    }

    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return APMAlertAnimation(presenting: false)
    }
}
