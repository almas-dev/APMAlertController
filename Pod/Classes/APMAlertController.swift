//
// Created by Alexander Maslennikov on 09.11.15.
//

import UIKit

@objc
public enum APMAlertControllerStyle: Int {
    case alert
    case actionSheet
}

@objc
open class APMAlertController: UIViewController {
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
    fileprivate var topScrollViewHeightConstraint: NSLayoutConstraint?
    fileprivate let contentView = UIView()
    fileprivate var anyTitleObject: AnyObject
    fileprivate var titleMessageSeparatorConstraint: NSLayoutConstraint?
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
            for (index, button) in buttons.enumerated() {
                button.setTitleColor(buttonTitleColor ?? tintColor, for: UIControlState())
                button.setTitleColor(buttonTitleColor ?? tintColor.withAlphaComponent(0.33), for: .highlighted)
                button.setTitleColor(buttonTitleColor ?? tintColor.withAlphaComponent(0.33), for: .selected)

                if let backgroundColor = buttonBackgroundColor {
                    button.backgroundColor = backgroundColor
                }

                button.topAnchor.constraint(equalTo: buttonsView.topAnchor, constant: 1).isActive = true
                button.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor).isActive = true

                if index == 0 {
                    button.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor).isActive = true
                } else {
                    let previousButton = buttons[index - 1]
                    button.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: 1).isActive = true
                    button.widthAnchor.constraint(equalTo: previousButton.widthAnchor).isActive = true
                }

                if index == buttons.count - 1 {
                    button.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor).isActive = true
                }
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardDidHide, object: nil)
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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(with:)),
            name: Notification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidHide(with:)),
            name: Notification.Name.UIKeyboardDidHide,
            object: nil
        )
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
            titleImageView.contentMode = .scaleAspectFit
            titleImageView.image = disableImageIconTemplate ? alertTitleImage : alertTitleImage?.withRenderingMode(.alwaysTemplate)
            titleImageView.alpha = 0.8
            contentView.addSubview(titleImageView)
        case let titleLabel as UILabel:
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            titleLabel.text = alertTitle
            contentView.addSubview(titleLabel)
        default:
            break
        }

        titleMessageSeparator.translatesAutoresizingMaskIntoConstraints = false
        titleMessageSeparator.backgroundColor = separatorColor
        titleMessageSeparator.isHidden = true
        contentView.addSubview(titleMessageSeparator)

        messageContentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageContentView)

        if alertMessage != nil || alertAttributedMessage != nil {
            let messageLabel = UILabel()
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
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

    private var centerYConstraint: NSLayoutConstraint?

    func configureLayout() {
        centerYConstraint = alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        centerYConstraint?.isActive = true
        alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alertView.widthAnchor.constraint(equalToConstant: 270).isActive = true
        alertView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, constant: -(verticalAlertIndent * 2)).isActive = true

        topScrollView.topAnchor.constraint(equalTo: alertView.topAnchor).isActive = true
        topScrollView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor).isActive = true
        topScrollView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor).isActive = true
        topScrollViewHeightConstraint = topScrollView.heightAnchor.constraint(equalToConstant: 0)
        topScrollViewHeightConstraint?.isActive = true

        configureTopScrollViewLayout()

        buttonsView.topAnchor.constraint(equalTo: topScrollView.bottomAnchor).isActive = true
        buttonsView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor).isActive = true
        buttonsView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor).isActive = true
        buttonsView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor).isActive = true
        buttonsView.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }

    func configureTopScrollViewLayout() {
        guard let titleObject = anyTitleObject as? UIView else {
            fatalError("anyTitleObject not UIView")
        }

        contentView.topAnchor.constraint(equalTo: topScrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: topScrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: topScrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: topScrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: topScrollView.widthAnchor).isActive = true

        titleObject.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        titleObject.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        titleObject.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true

        titleMessageSeparatorConstraint = titleMessageSeparator.topAnchor.constraint(equalTo: titleObject.bottomAnchor)
        titleMessageSeparatorConstraint?.isActive = true
        titleMessageSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleMessageSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleMessageSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        messageContentView.topAnchor.constraint(equalTo: titleMessageSeparator.bottomAnchor).isActive = true
        messageContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        messageContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        messageContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        if let messageLabel = self.messageLabel {
            messageLabel.topAnchor.constraint(equalTo: messageContentView.topAnchor, constant: 12).isActive = true
            messageLabel.leadingAnchor.constraint(equalTo: messageContentView.leadingAnchor, constant: 30).isActive = true
            messageLabel.rightAnchor.constraint(equalTo: messageContentView.rightAnchor, constant: -30).isActive = true
            messageLabel.bottomAnchor.constraint(equalTo: messageContentView.bottomAnchor, constant: -16).isActive = true
        }
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        topScrollView.updateConstraintsIfNeeded()
        topScrollView.contentSize = contentView.frame.size
        if view.frame.size.height - verticalAlertIndent * 2 - 45 >= contentView.frame.size.height {
            topScrollViewHeightConstraint?.constant = contentView.frame.size.height
        } else {
            topScrollViewHeightConstraint?.constant = view.frame.size.height - verticalAlertIndent * 2 - 45
        }

        titleMessageSeparator.isHidden = !showTitleMessageSeparator
        titleMessageSeparatorConstraint?.constant = showTitleMessageSeparator || (alertMessage == nil && alertAttributedMessage == nil) ? 14 : 0

        switch anyTitleObject {
        case let titleImageView as UIImageView:
            titleImageView.tintColor = tintColor
        case let titleLabel as UILabel:
            titleLabel.textColor = tintColor
        default:
            break
        }
        if let messageLabel = self.messageLabel, alertAttributedMessage == nil {
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

    func keyboardWillShow(with notification: Notification) {
        guard let centerYConstraint = self.centerYConstraint,
              let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
              let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return
        }

        let frame = keyboardFrame.cgRectValue
        centerYConstraint.constant = -frame.size.height / 2

        UIView.animate(withDuration: animationDuration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }

    func keyboardDidHide(with notification: Notification) {
        guard let centerYConstraint = self.centerYConstraint,
              let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return
        }

        centerYConstraint.constant = 0

        UIView.animate(withDuration: animationDuration.doubleValue) {
            self.view.layoutIfNeeded()
        }
    }
}

extension APMAlertController: UIViewControllerTransitioningDelegate {
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return APMAlertAnimation(presenting: true)
    }

    public func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return APMAlertAnimation(presenting: false)
    }
}
