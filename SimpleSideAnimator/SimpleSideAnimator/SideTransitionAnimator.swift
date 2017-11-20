//
//  SideTransitionAnimator.swift
//  SimpleSideAnimator
//
//  Created by moonCai on 2017/11/20.
//  Copyright © 2017年 moonCai. All rights reserved.
//

import UIKit

class SideTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var transitionDuration: TimeInterval = 0.25
    var widthScale: CGFloat = 0.5
    
    enum TransitionType {
        case dismiss
        case present
    }
    
    private let transitionType: TransitionType
    
    init(transitionType: TransitionType) {
        self.transitionType = transitionType
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionType {
        case .present:
            let containerView = transitionContext.containerView
            containerView.backgroundColor = UIColor(white: 0, alpha: 0)
            
            let toViewController = transitionContext.viewController(forKey: .to)!
            toViewController.view.frame.size.width = containerView.frame.width * widthScale
            toViewController.view.frame.origin.x = transitionContext.containerView.frame.width
            containerView.addSubview(toViewController.view)
            
            UIView.animate(withDuration: transitionDuration, animations: {
                toViewController.view.frame.origin.x -= toViewController.view.frame.width
                transitionContext.containerView.backgroundColor = UIColor(white: 0, alpha: 0.4)
            }, completion: { (_) in
                transitionContext.completeTransition(true)
            })
            
            //回调执行者
            let target = TapGestureRecognizerTarget()
            target.isHidden = true
            target.contentViewController = toViewController
            containerView.layer.addSublayer(target)
            let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: #selector(target.handleTap))
            tapGestureRecognizer.delegate = target
            containerView.addGestureRecognizer(tapGestureRecognizer)
        case .dismiss:
            let fromViewController = transitionContext.viewController(forKey: .from)!
            UIView.animate(withDuration: transitionDuration, animations: {
                fromViewController.view.frame.origin.x = transitionContext.containerView.frame.width
                transitionContext.containerView.backgroundColor = UIColor(white: 0, alpha: 0)
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        }
    }
    
    private class TapGestureRecognizerTarget: CALayer, UIGestureRecognizerDelegate {
        
        weak var contentViewController: UIViewController?
        
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            let point = gestureRecognizer.location(in: gestureRecognizer.view)
            if let viewController = contentViewController {
                return !viewController.view.frame.contains(point)
            }
            return true
        }
        
        @objc func handleTap() {
            contentViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

