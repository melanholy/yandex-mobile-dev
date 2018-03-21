//
//  ColorPickerView.swift
//  notebook
//
//  Created by Павел Кошара on 19/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CocoaLumberjack

class ColorPickerView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var colorPalette: ColorPalette!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var currentColorView: CurrentColor!
    @IBOutlet weak var paletteBorder: UIView!
    
    var targetColorLocation: CGPoint? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
    
    func setup() {
        Bundle.main.loadNibNamed("ColorPickerView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        paletteBorder.layer.borderColor = UIColor.black.cgColor
        paletteBorder.layer.borderWidth = 2
    }
    
    @IBAction func paletteOnTap(_ sender: Any, forEvent event: UIEvent) {
        guard let touches = event.touches(for: colorPalette),
              let location = touches.first?.location(in: colorPalette) else {
            return
        }
        guard let color = colorPalette.getColorAt(x: Int(location.x), y: Int(location.y)) else {
            DDLogError("Failed to get color from ColorPalette")
            return
        }
        
        currentColorView.setColor(color)
    }
    
    @IBAction func palleteOnPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let location = gestureRecognizer.location(in: colorPalette)
        var x = Int(location.x)
        x = min(x, Int(colorPalette.frame.width) - 1)
        x = max(x, 0)
        var y = Int(location.y)
        y = min(y, Int(colorPalette.frame.height) - 1)
        y = max(y, 0)
        
        guard let color = colorPalette.getColorAt(x: Int(x), y: Int(y)) else {
            DDLogError("Failed to get color from ColorPalette")
            return
        }
        
        currentColorView.setColor(color)
        targetColorLocation = CGPoint(x: colorPalette.frame.origin.x + location.x, y: colorPalette.frame.origin.y + location.y)
        
        setNeedsDisplay()
    }
    
    @IBAction func brightnessValueChanged(_ sender: UISlider) {
        colorPalette.setBrightess(brightnessSlider.value)
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            DDLogError("Failed to get current CGContext in ColorPickerView.draw")
            return
        }
        
        guard let circleCenter = targetColorLocation else {
            return
        }

        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.setFillColor(UIColor.red.cgColor)
        ctx.setLineWidth(10)
        ctx.addArc(
            center: CGPoint(x: 100, y: 60),
            radius: 20,
            startAngle: 0,
            endAngle: CGFloat.pi * 2,
            clockwise: false)
        ctx.strokePath()
    }
}
