//
// Created by Alexander Maslennikov on 09.11.15.
//

import UIKit
import SnapKit
import FontAwesome_swift
import ChameleonFramework

public enum APMAlertControllerStyle {
    case Alert
    case ActionSheet
}

public enum APMAlertIconTitleStyle {
    case Info
    case Positive
    case Negative
}

public class APMAlertController: UIViewController {
    private let alertView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let button = UIButton()
    private var alertTitle: String?
    private var iconTitleStyle: APMAlertIconTitleStyle?
    private var alertMessage: String?

    public required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }

    public convenience init(title: String?, message: String?, preferredStyle: APMAlertControllerStyle) {
        self.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.iconTitleStyle = nil
        self.alertMessage = message
        commonInit()
    }

    public convenience init(iconTitleStyle: APMAlertIconTitleStyle, message: String?, preferredStyle: APMAlertControllerStyle) {
        self.init(nibName: nil, bundle: nil)
        self.alertTitle = nil
        self.iconTitleStyle = iconTitleStyle
        self.alertMessage = message
        commonInit()
    }

    private func commonInit() {
        modalPresentationStyle = UIModalPresentationStyle.Custom
        transitioningDelegate = self
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        alertView.backgroundColor = UIColor(white: 1, alpha: 0.95)
        alertView.layer.cornerRadius = 12
        view.addSubview(alertView)
        alertView.snp_makeConstraints {
            make in
            make.centerY.equalTo(view.snp_centerY)
            make.left.equalTo(view.snp_left).offset(50)
            make.right.equalTo(view.snp_right).offset(-50)
            make.height.equalTo(192)
        }

        if let iconTitleStyle = self.iconTitleStyle {
            titleLabel.font = UIFont.fontAwesomeOfSize(48)
            titleLabel.textColor = UIColor.flatRedColorDark()
            titleLabel.text = String.fontAwesomeIconWithName(.TimesCircleO)
        } else {
            titleLabel.font = UIFont.boldSystemFontOfSize(16)
            titleLabel.text = alertTitle
        }
        titleLabel.textAlignment = .Center
        alertView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints {
            make in
            make.top.equalTo(alertView).offset(20)
            make.left.equalTo(alertView).offset(30)
            make.right.equalTo(alertView).offset(-30)
        }

        messageLabel.font = UIFont.systemFontOfSize(16)
        messageLabel.text = alertMessage
        messageLabel.numberOfLines = 2
        alertView.addSubview(messageLabel)
        messageLabel.snp_makeConstraints {
            make in
            make.top.equalTo(titleLabel.snp_bottom).offset(16)
            make.left.equalTo(alertView).offset(30)
            make.right.equalTo(alertView).offset(-30)
        }

        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0.75, alpha: 0.6)
        alertView.addSubview(separatorView)
        separatorView.snp_makeConstraints {
            make in
            make.left.equalTo(alertView)
            make.right.equalTo(alertView)
            make.bottom.equalTo(alertView).offset(-44)
            make.height.equalTo(1)
        }

        button.addTarget(self, action: "btnBackPressed:", forControlEvents: .TouchUpInside)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.setTitle("Go back!", forState: .Normal)
        alertView.addSubview(button)
        button.snp_makeConstraints {
            make in
            make.left.equalTo(alertView)
            make.right.equalTo(alertView)
            make.bottom.equalTo(alertView)
            make.height.equalTo(44)
        }
    }

    func btnBackPressed(button: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
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

class APMAlertAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let presenting: Bool

    init(presenting: Bool) {
        self.presenting = presenting
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        if (presenting) {
            return 0.5
        } else {
            return 0.3
        }
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if (presenting) {
            presentAnimateTransition(transitionContext)
        } else {
            dismissAnimateTransition(transitionContext)
        }
    }

    func presentAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let alertController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! APMAlertController
        let containerView = transitionContext.containerView()

        alertController.view.backgroundColor = UIColor.clearColor()
        alertController.alertView.alpha = 0.0
        alertController.alertView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        containerView!.addSubview(alertController.view)

        UIView.animateWithDuration(0.33,
                animations: {
                    alertController.view.backgroundColor = UIColor(white: 0, alpha: 0.4)
                    alertController.alertView.alpha = 1.0
                    alertController.alertView.transform = CGAffineTransformMakeScale(1.05, 1.05)
                },
                completion: {
                    finished in
                    UIView.animateWithDuration(0.2,
                            animations: {
                                alertController.alertView.transform = CGAffineTransformIdentity
                            },
                            completion: {
                                finished in
                                if (finished) {
                                    transitionContext.completeTransition(true)
                                }
                            })
                })
    }

    func dismissAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let alertController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! APMAlertController

        UIView.animateWithDuration(0.33,
                animations: {
                    alertController.view.backgroundColor = UIColor.clearColor()
                    alertController.alertView.alpha = 0.0
                    alertController.alertView.transform = CGAffineTransformMakeScale(0.9, 0.9)
                },
                completion: {
                    finished in
                    transitionContext.completeTransition(true)
                })
    }
}