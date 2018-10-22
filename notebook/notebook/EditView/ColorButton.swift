//
//  ColorButton.swift
//  notebook
//
//  Created by Павел Кошара on 18/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ColorButton: UIButton {
    public var isSelectedColor: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable public var color: UIColor? {
        didSet {
            layer.backgroundColor = color?.cgColor
        }
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        if (isSelectedColor) {
            let circleCenterX = Int(bounds.size.width - 15)
            let circleCenterY = 15
            ctx.setStrokeColor(UIColor.black.cgColor)
            ctx.setLineWidth(2)
            ctx.addArc(center: CGPoint(x: circleCenterX, y: circleCenterY),
                       radius: 10,
                       startAngle: 0,
                       endAngle: CGFloat.pi * 2,
                       clockwise: false)
            ctx.strokePath()
            
            ctx.move(to: CGPoint(x: circleCenterX - 7, y: circleCenterY))
            ctx.addLine(to: CGPoint(x: circleCenterX, y: circleCenterY + 7))
            ctx.addLine(to: CGPoint(x: circleCenterX + 5, y: circleCenterY - 6))
            ctx.strokePath()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
}
