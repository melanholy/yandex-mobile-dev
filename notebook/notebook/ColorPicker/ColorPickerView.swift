//
//  ColorPickerView.swift
//  notebook
//
//  Created by Павел Кошара on 19/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CocoaLumberjack

@objc protocol ColorPickerViewDeletegate {
    @objc optional func close(selectedColor: UIColor)
}

class ColorPickerView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var currentColorView: CurrentColor!
    @IBOutlet weak var colorPaletteView: UIView!
    @IBOutlet weak var colorTarget: ColorTarget!
    weak var delegate: ColorPickerViewDeletegate? = nil
    
    private var colorPalette: ColorPalette? = nil
    private var currentColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    private var colorTargetLocation: CGPoint? = nil
    
    override open class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    @IBAction func paletteOnTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: colorPaletteView)
        updateColor(paletteLocation: location)
    }
    
    @IBAction func palleteOnPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let location = gestureRecognizer.location(in: colorPaletteView)
        updateColor(paletteLocation: location)
    }
    
    @IBAction func doneButtonDidTap(_ sender: UIButton) {
        delegate?.close?(selectedColor: currentColor)
    }
    
    @IBAction func brightnessValueChanged(_ sender: UISlider) {
        colorPalette?.setBrightess(brightnessSlider.value)
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            DDLogError("Failed to get current CGContext in ColorPickerView.draw")
            return
        }
        
        guard let palette = colorPalette?.getImage() else {
            return
        }
        
        ctx.draw(palette, in: CGRect(
            x: colorPaletteView.frame.origin.x + 2,
            y: colorPaletteView.frame.origin.y + 2,
            width: colorPaletteView.frame.width - 4,
            height: colorPaletteView.frame.height - 4))
    }
    
    override func layoutSubviews() {
        if (colorPalette == nil) {
            colorPalette = ColorPalette(
                width: Float(colorPaletteView.frame.width) - 4,
                height: Float(colorPaletteView.frame.height) - 4)
        }
        
        if let colorTargetLocation = colorTargetLocation {
            colorTarget.frame.origin.x = colorTargetLocation.x
            colorTarget.frame.origin.y = colorTargetLocation.y
        } else {
            colorTarget.frame.origin.x = -100
            colorTarget.frame.origin.y = -100
        }
    }
    
    private func updateColor(paletteLocation: CGPoint) {
        var x = paletteLocation.x - 2
        x = min(x, colorPaletteView.frame.width - 5)
        x = max(x, 0)
        var y = paletteLocation.y - 2
        y = min(y, colorPaletteView.frame.height - 5)
        y = max(y, 0)
        
        guard let color = colorPalette?.getColorAt(x: Int(x), y: Int(y)) else {
            DDLogError("Failed to get color from ColorPalette")
            return
        }
        
        currentColor = color
        currentColorView.setColor(color)
        colorTargetLocation = CGPoint(
            x: x - colorTarget.frame.width / 2,
            y: y - colorTarget.frame.height / 2)
        setNeedsLayout()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("ColorPickerView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        colorPaletteView.layer.borderColor = UIColor.black.cgColor
        colorPaletteView.layer.borderWidth = 2
        colorPaletteView.clipsToBounds = true
    }
}
