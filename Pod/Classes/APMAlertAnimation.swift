//
// Created by Xander on 04.03.16.
//

import Foundation

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
