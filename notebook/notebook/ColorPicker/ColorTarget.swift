//
//  ColorTarget.swift
//  notebook
//
//  Created by Павел Кошара on 24/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CocoaLumberjack

class ColorTarget: UIView {
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            DDLogError("Failed to get current CGContext in ColorTarget.draw")
            return
        }
        
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.setLineWidth(2)
        ctx.addArc(
            center: center,
            radius: 11,
            startAngle: 0,
            endAngle: CGFloat.pi * 2,
            clockwise: false)
        
        ctx.move(to: CGPoint(x: center.x, y: center.y - 12))
        ctx.addLine(to: CGPoint(x: center.x, y: center.y - 16))
        ctx.move(to: CGPoint(x: center.x, y: center.y + 12))
        ctx.addLine(to: CGPoint(x: center.x, y: center.y + 16))
        ctx.move(to: CGPoint(x: center.x - 12, y: center.y))
        ctx.addLine(to: CGPoint(x: center.x - 16, y: center.y))
        ctx.move(to: CGPoint(x: center.x + 12, y: center.y))
        ctx.addLine(to: CGPoint(x: center.x + 16, y: center.y))
        
        ctx.strokePath()
    }
}
