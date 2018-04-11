//
//  ColorPickerAnimation.swift
//  notebook
//
//  Created by Павел Кошара on 01/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ColorPickerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: .from),
            let to = transitionContext.viewController(forKey: .to),
            let colorPicker = isPresenting ? to.view : from.view else {
            return
        }
        
        let container = transitionContext.containerView
        colorPicker.bounds.size = container.frame.size
        colorPicker.frame.size = container.frame.size
        
        let leftWidth = floor(colorPicker.bounds.width / 2)
        let rightWidth = colorPicker.bounds.width - leftWidth
        let upperHeight = floor(colorPicker.bounds.height / 2)
        let bottomHeight = colorPicker.bounds.height - upperHeight
        let pieceSizes = [
            CGRect(x: 0, y: 0, width: leftWidth, height: upperHeight),
            CGRect(x: leftWidth, y: 0, width: rightWidth, height: upperHeight),
            CGRect(x: 0, y: upperHeight, width: leftWidth, height: bottomHeight),
            CGRect(x: leftWidth, y: upperHeight, width: rightWidth, height: bottomHeight)
        ]
        var pieces = [UIImageView]()
        for pieceSize in pieceSizes {
            guard let snapshotImage = UIImage(view: colorPicker, in: pieceSize) else {
                return
            }
            let snapshotView = UIImageView(image: snapshotImage)
            snapshotView.frame.size = CGSize(width: pieceSize.width, height: pieceSize.height)
            pieces.append(snapshotView)
        }
        
        if isPresenting {
            placePiecesApart(pieces: pieces, container: container)
        } else {
            placePiecesTogether(pieces: pieces)
        }
        
        container.subviews.forEach { $0.removeFromSuperview() }
        pieces.forEach { container.addSubview($0) }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            if self.isPresenting {
                self.placePiecesTogether(pieces: pieces)
            } else {
                self.placePiecesApart(pieces: pieces, container: container)
            }
        }, completion: { (finished) in
            container.subviews.forEach { $0.removeFromSuperview() }
            if self.isPresenting {
                container.addSubview(colorPicker)
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    private func placePiecesApart(pieces: [UIImageView], container: UIView) {
        pieces[0].frame.origin = CGPoint(x: -pieces[0].frame.width, y: -pieces[0].frame.height)
        pieces[1].frame.origin = CGPoint(x: container.frame.width, y: -pieces[1].frame.height)
        pieces[2].frame.origin = CGPoint(x: -pieces[2].frame.width, y: container.frame.height)
        pieces[3].frame.origin = CGPoint(x: container.frame.width, y: container.frame.height)
    }
    
    private func placePiecesTogether(pieces: [UIImageView]) {
        pieces[0].frame.origin = CGPoint(x: 0, y: 0)
        pieces[1].frame.origin = CGPoint(x: pieces[0].frame.width, y: 0)
        pieces[2].frame.origin = CGPoint(x: 0, y: pieces[0].frame.height)
        pieces[3].frame.origin = CGPoint(x: pieces[2].frame.width, y: pieces[1].frame.height)
    }
}
