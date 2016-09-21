//
// Created by Xander on 04.03.16.
//

import Foundation

class APMAlertAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let presenting: Bool

    init(presenting: Bool) {
        self.presenting = presenting
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if (presenting) {
            return 0.5
        } else {
            return 0.3
        }
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if (presenting) {
            presentAnimateTransition(transitionContext)
        } else {
            dismissAnimateTransition(transitionContext)
        }
    }

    func presentAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let alertController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! APMAlertController
        let containerView = transitionContext.containerView

        alertController.view.backgroundColor = UIColor.clear
        alertController.alertView.alpha = 0.0
        alertController.alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        containerView.addSubview(alertController.view)

        UIView.animate(withDuration: 0.33,
                animations: {
                    alertController.view.backgroundColor = UIColor(white: 0, alpha: 0.4)
                    alertController.alertView.alpha = 1.0
                    alertController.alertView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                },
                completion: {
                    finished in
                    UIView.animate(withDuration: 0.2,
                            animations: {
                                alertController.alertView.transform = CGAffineTransform.identity
                            },
                            completion: {
                                finished in
                                if (finished) {
                                    transitionContext.completeTransition(true)
                                }
                            })
                })
    }

    func dismissAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let alertController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! APMAlertController

        UIView.animate(withDuration: 0.33,
                animations: {
                    alertController.view.backgroundColor = UIColor.clear
                    alertController.alertView.alpha = 0.0
                    alertController.alertView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                },
                completion: {
                    finished in
                    transitionContext.completeTransition(true)
                })
    }
}
