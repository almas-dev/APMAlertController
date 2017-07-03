//
// Created by Alexander Maslennikov on 09.11.15.
//

import UIKit

public enum APMAlertControllerStyle {
    case alert
    case actionSheet
}

open class APMAlertController: UIViewController {
    fileprivate let verticalAlertIndent: CGFloat = 25

    open var buttonTitleColor: UIColor?

    open var customButtonFont: UIFont? {
        didSet {
            buttonsContainerView.arrangedSubviews
                .flatMap { $0 as? UIButton }
                .forEach { $0.titleLabel?.font = customButtonFont }
        }
    }

    open var buttonBackgroundColor: UIColor? {
        didSet {
            buttonsContainerView.arrangedSubviews
                .flatMap { $0 as? UIButton }
                .forEach { $0.backgroundColor = buttonBackgroundColor ?? .white }
        }
    }
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
    fileprivate var anyTitleView: UIView
    fileprivate var titleMessageSeparatorConstraint: NSLayoutConstraint?
    fileprivate let titleMessageSeparator = UIView()
    fileprivate var messageLabel: UILabel?
    fileprivate lazy var buttonsContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    fileprivate var alertTitle: String?
    fileprivate var alertTitleImage: UIImage?
    fileprivate var alertMessage: String?
    fileprivate var alertAttributedMessage: NSAttributedString?
    fileprivate var actions = [APMAlertActionProtocol]()
    fileprivate var centerYConstraint: NSLayoutConstraint?

    // MARK: - Constructors

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardDidHide, object: nil)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    init(titleObject: UIView) {
        self.anyTitleView = titleObject
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

    // MARK: - View Controller lifecycle

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

        switch anyTitleView {
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

    // MARK: - Public methods

    open func addAction(_ action: APMAlertActionProtocol) {
        actions.append(action)

        let button = UIButton()
        if let buttonFont = self.customButtonFont {
            button.titleLabel?.font = buttonFont
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(action.title, for: .normal)
        button.setTitleColor(buttonTitleColor ?? tintColor, for: .normal)
        button.setTitleColor(buttonTitleColor ?? tintColor.withAlphaComponent(0.33), for: .highlighted)
        button.setTitleColor(buttonTitleColor ?? tintColor.withAlphaComponent(0.33), for: .selected)

        button.backgroundColor = buttonBackgroundColor ?? .white
        button.addTarget(self, action: #selector(btnPressed(_:)), for: .touchUpInside)
        buttonsContainerView.addArrangedSubview(button)
        button.tag = buttonsContainerView.arrangedSubviews.count

        if buttonsContainerView.arrangedSubviews.count > 1 {
            let lineView = LineView(axis: .vertical)
            lineView.backgroundColor = separatorColor
            lineView.placeAboveView(button)
        }
    }
}

// MARK: - Keyboard handlers

extension APMAlertController {
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

// MARK: - Private methods

private extension APMAlertController {

    @objc
    func btnPressed(_ button: UIButton) {
        button.isSelected = true
        self.dismiss(animated: true, completion: {
            let action = self.actions[button.tag - 1]
            action.handler?(action)
        })
    }

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

        buttonsContainerView.topAnchor.constraint(equalTo: topScrollView.bottomAnchor).isActive = true
        buttonsContainerView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor).isActive = true
        buttonsContainerView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor).isActive = true
        buttonsContainerView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor).isActive = true
        buttonsContainerView.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }

    func configureTopScrollViewLayout() {
        contentView.topAnchor.constraint(equalTo: topScrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: topScrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: topScrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: topScrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: topScrollView.widthAnchor).isActive = true

        anyTitleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        anyTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        anyTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true

        titleMessageSeparatorConstraint = titleMessageSeparator.topAnchor.constraint(equalTo: anyTitleView.bottomAnchor)
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

    func configureTopScrollView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        topScrollView.addSubview(contentView)

        anyTitleView.translatesAutoresizingMaskIntoConstraints = false
        switch anyTitleView {
        case let titleImageView as UIImageView:
            titleImageView.contentMode = .scaleAspectFit
            titleImageView.image = disableImageIconTemplate ? alertTitleImage : alertTitleImage?.withRenderingMode(.alwaysTemplate)
            titleImageView.alpha = 0.8
        case let titleLabel as UILabel:
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            titleLabel.text = alertTitle
        default:
            break
        }
        contentView.addSubview(anyTitleView)

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


    func configureView() {
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.backgroundColor = UIColor(white: 1, alpha: 0.95)
        alertView.layer.cornerRadius = 12
        alertView.clipsToBounds = true
        view.addSubview(alertView)

        topScrollView.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(topScrollView)

        configureTopScrollView()

        buttonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(buttonsContainerView)
        let lineView = LineView(axis: .horizontal)
        lineView.backgroundColor = separatorColor
        lineView.placeAboveView(buttonsContainerView)
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

private final class LineView: UIView {

    required init(coder _: NSCoder) {
        fatalError("NSCoding not supported")
    }

    enum LineAxis {
        case horizontal, vertical
    }

    private let axis: LineAxis
    init(axis: LineAxis) {
        self.axis = axis
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        switch axis {
        case .horizontal:
            heightAnchor.constraint(equalToConstant: 1).isActive = true
        case .vertical:
            widthAnchor.constraint(equalToConstant: 1).isActive = true
        }
    }

    func placeAboveView(_ view: UIView) {
        view.addSubview(self)
        switch axis {
        case .horizontal:
            NSLayoutConstraint.activate([
                view.leftAnchor.constraint(equalTo: leftAnchor),
                view.topAnchor.constraint(equalTo: topAnchor),
                view.rightAnchor.constraint(equalTo: rightAnchor)
            ])
        case .vertical:
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
                view.leftAnchor.constraint(equalTo: leftAnchor)
            ])
        }
    }
}
