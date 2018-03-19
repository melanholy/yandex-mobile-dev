//
//  ColorButton.swift
//  notebook
//
//  Created by Павел Кошара on 18/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ColorButton: UIButton {
    private var selectedColor: Bool = false
    
    init(color: UIColor) {
        super.init(frame: CGRect.zero)
        
        setup(color)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(_ color: UIColor? = nil) {
        if color != nil {
            self.backgroundColor = color
        }
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        if (selectedColor)
        {
            ctx.setStrokeColor(UIColor.black.cgColor)
            ctx.setLineWidth(2)
            ctx.addArc(center: CGPoint(x: bounds.size.width - 10, y: 10),
                       radius: 5,
                       startAngle: 0,
                       endAngle: CGFloat.pi * 2,
                       clockwise: false)
            ctx.strokePath()
        }
    }
    
    public func select() {
        selectedColor = true
        setNeedsDisplay()
    }
    
    public func deselect() {
        selectedColor = false
        setNeedsDisplay()
    }
}
