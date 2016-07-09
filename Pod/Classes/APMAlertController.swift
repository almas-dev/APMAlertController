//
// Created by Alexander Maslennikov on 09.11.15.
//

import UIKit

@objc public enum APMAlertControllerStyle: Int {
    case Alert
    case ActionSheet
}

@objc public class APMAlertController: UIViewController {
    private let verticalAlertIndent: CGFloat = 25

    public var buttonTitleColor: UIColor?
    public var buttonBackgroundColor: UIColor?
    public var separatorColor = UIColor(white: 0.75, alpha: 0.6)
    public var showTitleMessageSeparator: Bool = false
    public var tintColor: UIColor = UIColor.blackColor()
    public let messageContentView: UIView = UIView()

    let alertView = UIView()
    private let topScrollView = UIScrollView()
    private var topScrollViewHeightConstraint = NSLayoutConstraint()
    private let contentView = UIView()
    private var anyTitleObject: AnyObject
    private var topTitleMessageSeparatorConstraint = NSLayoutConstraint()
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
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.backgroundColor = UIColor(white: 1, alpha: 0.95)
        alertView.layer.cornerRadius = 12
        alertView.clipsToBounds = true
        view.addSubview(alertView)

        topScrollView.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(topScrollView)

        configureTopScrollView()

        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.backgroundColor = separatorColor
        alertView.addSubview(buttonsView)
    }

    func configureTopScrollView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        topScrollView.addSubview(contentView)

        switch anyTitleObject {
        case let titleImageView as UIImageView:
            titleImageView.translatesAutoresizingMaskIntoConstraints = false
            titleImageView.contentMode = .ScaleAspectFit
            titleImageView.image = alertTitleImage?.imageWithRenderingMode(.AlwaysTemplate)
            titleImageView.alpha = 0.8
            contentView.addSubview(titleImageView)
        case let titleLabel as UILabel:
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont.boldSystemFontOfSize(16)
            titleLabel.textAlignment = .Center
            titleLabel.numberOfLines = 0
            titleLabel.text = alertTitle
            contentView.addSubview(titleLabel)
        default:
            break
        }

        titleMessageSeparator.translatesAutoresizingMaskIntoConstraints = false
        titleMessageSeparator.backgroundColor = separatorColor
        titleMessageSeparator.hidden = true
        contentView.addSubview(titleMessageSeparator)

        messageContentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageContentView)

        if alertMessage != nil || alertAttributedMessage != nil {
            messageLabel = UILabel()
        }

        if let messageLabel = self.messageLabel {
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.font = UIFont.systemFontOfSize(16)
            messageLabel.textAlignment = .Center
            if let alertMessage = self.alertMessage {
                messageLabel.text = alertMessage
            }
            if let alertAttributedMessage = self.alertAttributedMessage {
                messageLabel.attributedText = alertAttributedMessage
            }
            messageLabel.numberOfLines = 0
            messageContentView.addSubview(messageLabel)
        }
    }

    func configureLayout() {
        view.addConstraints([
                NSLayoutConstraint(item: alertView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: alertView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: alertView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 270),
                NSLayoutConstraint(item: alertView, attribute: .Height, relatedBy: .LessThanOrEqual, toItem: view, attribute: .Height, multiplier: 1.0, constant: -(verticalAlertIndent * 2))
        ])

        topScrollViewHeightConstraint = NSLayoutConstraint(item: topScrollView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0)

        alertView.addConstraints([
                NSLayoutConstraint(item: topScrollView, attribute: .Top, relatedBy: .Equal, toItem: alertView, attribute: .Top, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: topScrollView, attribute: .Left, relatedBy: .Equal, toItem: alertView, attribute: .Left, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: topScrollView, attribute: .Right, relatedBy: .Equal, toItem: alertView, attribute: .Right, multiplier: 1.0, constant: 0),
                topScrollViewHeightConstraint
        ])

        configureTopScrollViewLayout()

        alertView.addConstraints([
                NSLayoutConstraint(item: buttonsView, attribute: .Top, relatedBy: .Equal, toItem: topScrollView, attribute: .Bottom, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: buttonsView, attribute: .Left, relatedBy: .Equal, toItem: alertView, attribute: .Left, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: buttonsView, attribute: .Right, relatedBy: .Equal, toItem: alertView, attribute: .Right, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: buttonsView, attribute: .Bottom, relatedBy: .Equal, toItem: alertView, attribute: .Bottom, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: buttonsView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 45)
        ])
    }

    func configureTopScrollViewLayout() {
        topScrollView.addConstraints([
                NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: topScrollView, attribute: .Top, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: contentView, attribute: .Left, relatedBy: .Equal, toItem: topScrollView, attribute: .Left, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: contentView, attribute: .Right, relatedBy: .Equal, toItem: topScrollView, attribute: .Right, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .Equal, toItem: topScrollView, attribute: .Bottom, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: contentView, attribute: .Width, relatedBy: .Equal, toItem: topScrollView, attribute: .Width, multiplier: 1.0, constant: 0)
        ])

        contentView.addConstraints([
                NSLayoutConstraint(item: anyTitleObject, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1.0, constant: 20),
                NSLayoutConstraint(item: anyTitleObject, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1.0, constant: 30),
                NSLayoutConstraint(item: anyTitleObject, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: -30)
        ])

        topTitleMessageSeparatorConstraint = NSLayoutConstraint(item: titleMessageSeparator, attribute: .Top, relatedBy: .Equal, toItem: anyTitleObject, attribute: .Bottom, multiplier: 1.0, constant: 0)

        contentView.addConstraints([
                topTitleMessageSeparatorConstraint,
                NSLayoutConstraint(item: titleMessageSeparator, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: titleMessageSeparator, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: titleMessageSeparator, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 1)
        ])

        contentView.addConstraints([
                NSLayoutConstraint(item: messageContentView, attribute: .Top, relatedBy: .Equal, toItem: titleMessageSeparator, attribute: .Bottom, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: messageContentView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: messageContentView, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: messageContentView, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1.0, constant: 0)
        ])

        if let messageLabel = self.messageLabel {
            messageContentView.addConstraints([
                    NSLayoutConstraint(item: messageLabel, attribute: .Top, relatedBy: .Equal, toItem: messageContentView, attribute: .Top, multiplier: 1.0, constant: 12),
                    NSLayoutConstraint(item: messageLabel, attribute: .Left, relatedBy: .Equal, toItem: messageContentView, attribute: .Left, multiplier: 1.0, constant: 30),
                    NSLayoutConstraint(item: messageLabel, attribute: .Right, relatedBy: .Equal, toItem: messageContentView, attribute: .Right, multiplier: 1.0, constant: -30),
                    NSLayoutConstraint(item: messageLabel, attribute: .Bottom, relatedBy: .Equal, toItem: messageContentView, attribute: .Bottom, multiplier: 1.0, constant: -16)
            ])
        }
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        topScrollView.updateConstraintsIfNeeded()
        topScrollView.contentSize = contentView.frame.size
        if view.frame.size.height - verticalAlertIndent * 2 - 45 >= contentView.frame.size.height {
            topScrollViewHeightConstraint.constant = contentView.frame.size.height
        } else {
            topScrollViewHeightConstraint.constant = view.frame.size.height - verticalAlertIndent * 2 - 45
        }

        titleMessageSeparator.hidden = !showTitleMessageSeparator
        topTitleMessageSeparatorConstraint.constant = showTitleMessageSeparator || (alertMessage == nil && alertAttributedMessage == nil) ? 14 : 0

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
