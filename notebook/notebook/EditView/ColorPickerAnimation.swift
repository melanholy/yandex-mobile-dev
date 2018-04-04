//
//  ColorPickerAnimation.swift
//  notebook
//
//  Created by Павел Кошара on 01/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ColorPickerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let originFrame: CGRect
    private let isPresenting: Bool
    
    init(originFrame: CGRect, isPresenting: Bool) {
        self.originFrame = originFrame
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        let container = transitionContext.containerView
        
        container.addSubview(toView)
        
        let colorPickerView = isPresenting ? toView : fromView
        
        toView.frame = isPresenting
            ? originFrame
            : toView.frame
        toView.alpha = isPresenting ? 0 : 1
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            colorPickerView.frame = self.isPresenting
                ? fromView.frame
                : self.originFrame
            colorPickerView.alpha = self.isPresenting ? 1 : 0
        }, completion: { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
