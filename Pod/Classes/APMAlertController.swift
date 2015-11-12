//
// Created by Alexander Maslennikov on 09.11.15.
//

import UIKit
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

public enum APMAlertActionStyle {
    case Default
    case Cancel
    case Destructive
}

public class APMAlertController: UIViewController {
    private let alertView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let buttonsView = UIView()
    private let button = UIButton()
    private var alertTitle: String?
    private var iconTitleStyle: APMAlertIconTitleStyle?
    private var alertMessage: String?
    private var actions = [APMAlertAction]()
    private var buttons: [UIButton] = [] {
        didSet {
            buttonsView.removeConstraints(buttonsView.constraints)
            for (index, value) in buttons.enumerate() {
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

        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.backgroundColor = UIColor(white: 1, alpha: 0.95)
        alertView.layer.cornerRadius = 12
        alertView.clipsToBounds = true
        view.addSubview(alertView)
        view.addConstraints([
                NSLayoutConstraint(item: alertView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: alertView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 50),
                NSLayoutConstraint(item: alertView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -50)
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
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
        alertView.addConstraints([
                NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: alertView, attribute: .Top, multiplier: 1.0, constant: 20),
                NSLayoutConstraint(item: titleLabel, attribute: .Left, relatedBy: .Equal, toItem: alertView, attribute: .Left, multiplier: 1.0, constant: 30),
                NSLayoutConstraint(item: titleLabel, attribute: .Right, relatedBy: .Equal, toItem: alertView, attribute: .Right, multiplier: 1.0, constant: -30)
        ])

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = UIFont.systemFontOfSize(16)
        messageLabel.textAlignment = .Center
        messageLabel.text = alertMessage
        messageLabel.numberOfLines = 0
        alertView.addSubview(messageLabel)
        alertView.addConstraints([
                NSLayoutConstraint(item: messageLabel, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Bottom, multiplier: 1.0, constant: 12),
                NSLayoutConstraint(item: messageLabel, attribute: .Left, relatedBy: .Equal, toItem: alertView, attribute: .Left, multiplier: 1.0, constant: 30),
                NSLayoutConstraint(item: messageLabel, attribute: .Right, relatedBy: .Equal, toItem: alertView, attribute: .Right, multiplier: 1.0, constant: -30)
        ])

        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.backgroundColor = UIColor(white: 0.75, alpha: 0.6)
        alertView.addSubview(buttonsView)
        alertView.addConstraints([
                NSLayoutConstraint(item: buttonsView, attribute: .Top, relatedBy: .Equal, toItem: messageLabel, attribute: .Bottom, multiplier: 1.0, constant: 18),
                NSLayoutConstraint(item: buttonsView, attribute: .Left, relatedBy: .Equal, toItem: alertView, attribute: .Left, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: buttonsView, attribute: .Right, relatedBy: .Equal, toItem: alertView, attribute: .Right, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: buttonsView, attribute: .Bottom, relatedBy: .Equal, toItem: alertView, attribute: .Bottom, multiplier: 1.0, constant: 0),
                NSLayoutConstraint(item: buttonsView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 45)
        ])
    }

    public func addAction(action: APMAlertAction) {
        actions.append(action)

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.setTitle(action.title, forState: .Normal)
        button.addTarget(self, action: "btnPressed:", forControlEvents: .TouchUpInside)
        button.tag = buttons.count + 1
        button.backgroundColor = UIColor.whiteColor()
        buttonsView.addSubview(button)
        buttons.append(button)
    }

    func btnPressed(button: UIButton) {
        button.selected = true
        let action = actions[button.tag - 1]
        if (action.handler != nil) {
            action.handler(action)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
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

public class APMAlertAction : NSObject {
    let title: String
    let style: APMAlertActionStyle
    let handler: ((APMAlertAction!) -> Void)!

    public required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    public init(title: String, style: APMAlertActionStyle, handler: ((APMAlertAction!) -> Void)!) {
        self.title = title
        self.style = style
        self.handler = handler
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