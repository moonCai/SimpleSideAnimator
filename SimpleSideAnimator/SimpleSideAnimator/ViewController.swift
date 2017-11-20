//
//  ViewController.swift
//  SimpleSideAnimator
//
//  Created by moonCai on 2017/11/21.
//  Copyright © 2017年 moonCai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let presentBtn = UIButton(type: .contactAdd)
        presentBtn.center = view.center
        presentBtn.addTarget(self, action: #selector(presentBtnAction), for: .touchUpInside)
        view.addSubview(presentBtn)
    }
    
    @objc private func presentBtnAction() {
        let rightVC = RightViewController()
        rightVC.transitioningDelegate = self
        rightVC.modalPresentationStyle = .custom
        present(rightVC, animated: true, completion: nil)
    }
    
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = SideTransitionAnimator(transitionType: .present)
        //自定义toViewController的宽度
        animator.widthScale = 0.4
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SideTransitionAnimator(transitionType: .dismiss)
    }
    
}



