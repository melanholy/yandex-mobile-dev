//
//  RemoveSymbol.swift
//  notebook
//
//  Created by Павел Кошара on 24/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class RemoveSymbol: UIView {
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let circleCenter = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let circleRadius = frame.width / 2 - 2
        
        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.setLineWidth(4)
        ctx.addArc(
            center: circleCenter,
            radius: circleRadius,
            startAngle: 0,
            endAngle: CGFloat.pi * 2,
            clockwise: false)
        
        ctx.move(to: CGPoint(x: circleCenter.x - circleRadius / 2, y: circleCenter.y - circleRadius / 2))
        ctx.addLine(to: CGPoint(x: circleCenter.x + circleRadius / 2, y: circleCenter.y + circleRadius / 2))
        ctx.move(to: CGPoint(x: circleCenter.x + circleRadius / 2, y: circleCenter.y - circleRadius / 2))
        ctx.addLine(to: CGPoint(x: circleCenter.x - circleRadius / 2, y: circleCenter.y + circleRadius / 2))
        
        ctx.strokePath()
    }
}
