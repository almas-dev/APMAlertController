//
// Created by Alexander Maslennikov on 09.11.15.
//

import UIKit

open class APMAlertController: UIViewController {

    public enum Style {
        case alert
        case actionSheet
    }

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
    open private(set) lazy var messageContentView: UIStackView = {
        let stackView = UIStackView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 30, bottom: 15, right: 30)
        stackView.alignment = .fill
        return stackView
    }()

    let alertView = UIView()
    fileprivate let topScrollView = UIScrollView()
    fileprivate var topScrollViewHeightConstraint: NSLayoutConstraint?
    fileprivate let contentView = UIView()
    fileprivate var titleMessageSeparatorConstraint: NSLayoutConstraint?

    private(set) lazy var titleMessageSeparator: UIView = {
        let view = LineView(axis: .horizontal)
        view.backgroundColor = self.separatorColor
        view.isHidden = true
        return view
    }()

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

    public required init(coder _: NSCoder) {
        fatalError("NSCoding not supported")
    }

    public init() {
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = UIModalPresentationStyle.custom
        transitioningDelegate = self
    }

    public convenience init(title: String?, message: String?, preferredStyle _: Style) {
        self.init()
        alertTitle = title
        alertMessage = message
    }

    public convenience init(title: String?, attributedMessage: NSAttributedString?, preferredStyle _: Style) {
        self.init()
        alertTitle = title
        alertAttributedMessage = attributedMessage
    }

    public convenience init(titleImage: UIImage?, message: String?, preferredStyle _: Style) {
        self.init()
        alertTitleImage = titleImage
        alertMessage = message
    }

    public convenience init(title: String?, preferredStyle _: Style) {
        self.init()
        alertTitle = title
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
        topScrollView.contentSize = contentStackView.frame.size
        if view.frame.size.height - verticalAlertIndent * 2 - 45 >= contentStackView.frame.size.height {
            topScrollViewHeightConstraint?.constant = contentStackView.frame.size.height
        } else {
            topScrollViewHeightConstraint?.constant = view.frame.size.height - verticalAlertIndent * 2 - 45
        }

        titleMessageSeparator.isHidden = !showTitleMessageSeparator

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

    // MARK: - Content sections

    public private(set) lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 15, left: 30, bottom: 0, right: 30)
        if self.alertTitleImage != nil {
            stackView.addArrangedSubview(self.titleImageView)
        } else if self.alertTitle != nil {
            stackView.addArrangedSubview(self.titleLabel)
        }
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = self.tintColor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = self.alertTitle
        return titleLabel
    }()

    private lazy var titleImageView: UIImageView = {
        let titleImageView = UIImageView()
        titleImageView.tintColor = self.tintColor
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.image = self.disableImageIconTemplate ? self.alertTitleImage : self.alertTitleImage?.withRenderingMode(.alwaysTemplate)
        titleImageView.alpha = 0.8
        return titleImageView
    }()

    fileprivate lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
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
        dismiss(animated: true, completion: {
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
    }

    func configureTopScrollView() {
        topScrollView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topScrollView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: topScrollView.bottomAnchor),
            contentStackView.leftAnchor.constraint(equalTo: topScrollView.leftAnchor),
            contentStackView.rightAnchor.constraint(equalTo: topScrollView.rightAnchor),
            contentStackView.widthAnchor.constraint(equalTo: topScrollView.widthAnchor)
        ])

        contentStackView.addArrangedSubview(titleStackView)
        contentStackView.addArrangedSubview(titleMessageSeparator)
        contentStackView.addArrangedSubview(messageContentView)

        if alertMessage != nil || alertAttributedMessage != nil {
            let messageLabel = UILabel()
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.font = customDescriptionFont ?? UIFont.systemFont(ofSize: 16)
            messageLabel.textAlignment = .center
            if let alertMessage = self.alertMessage {
                messageLabel.text = alertMessage
            } else if let alertAttributedMessage = self.alertAttributedMessage {
                messageLabel.attributedText = alertAttributedMessage
            }
            messageLabel.numberOfLines = 0
            messageContentView.addArrangedSubview(messageLabel)

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
        let topScrollViewHeightConstraint = topScrollView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            topScrollView.topAnchor.constraint(equalTo: alertView.topAnchor),
            topScrollView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            topScrollView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            topScrollViewHeightConstraint
        ])
        self.topScrollViewHeightConstraint = topScrollViewHeightConstraint

        buttonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(buttonsContainerView)
        NSLayoutConstraint.activate([
            buttonsContainerView.topAnchor.constraint(equalTo: topScrollView.bottomAnchor),
            buttonsContainerView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            buttonsContainerView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            buttonsContainerView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor),
            buttonsContainerView.heightAnchor.constraint(equalToConstant: 45)
        ])

        let lineView = LineView(axis: .horizontal)
        lineView.backgroundColor = separatorColor
        lineView.placeAboveView(buttonsContainerView)

        configureTopScrollView()
    }
}

extension APMAlertController: UIViewControllerTransitioningDelegate {
    public func animationController(
        forPresented _: UIViewController,
        presenting _: UIViewController,
        source _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return APMAlertAnimation(presenting: true)
    }

    public func animationController(
        forDismissed _: UIViewController
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
            let constraint = heightAnchor.constraint(equalToConstant: 1)
            constraint.priority = 999
            constraint.isActive = true
        case .vertical:
            let constraint = widthAnchor.constraint(equalToConstant: 1)
            constraint.priority = 999
            constraint.isActive = true
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
