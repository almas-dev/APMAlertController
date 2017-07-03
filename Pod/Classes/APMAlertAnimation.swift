//
// Created by Xander on 04.03.16.
//

import UIKit

class APMAlertAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let presenting: Bool

    init(presenting: Bool) {
        self.presenting = presenting
    }

    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presenting ? 0.5 : 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        presenting ? presentAnimateTransition(transitionContext) : dismissAnimateTransition(transitionContext)
    }

    func presentAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        if let alertController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? APMAlertController {
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
                           completion: { finished in
                               UIView.animate(withDuration: 0.2,
                                              animations: {
                                                  alertController.alertView.transform = CGAffineTransform.identity
                                              },
                                              completion: { finished in
                                                  if finished {
                                                      transitionContext.completeTransition(true)
                                                  }
                               })
            })
        }
    }

    func dismissAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        if let alertController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? APMAlertController {

            UIView.animate(withDuration: 0.33,
                           animations: {
                               alertController.view.backgroundColor = UIColor.clear
                               alertController.alertView.alpha = 0.0
                               alertController.alertView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                           },
                           completion: { _ in
                               transitionContext.completeTransition(true)
            })
        }
    }
}
