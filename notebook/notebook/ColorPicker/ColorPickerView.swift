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
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var brightnessSlider: UISlider!
    @IBOutlet private weak var currentColorView: CurrentColorView!
    @IBOutlet private weak var colorPaletteView: ColorPaletteView!
    @IBOutlet private weak var colorTarget: ColorTarget!
    @IBOutlet private weak var paletteBorderView: UIView!
    
    public var state: ColorPickerState {
        didSet {
            currentColorView.setColor(state.selectedColor)
            colorPaletteView.setBrightness(state.brightness)
            brightnessSlider.value = state.brightness
            if let colorLocation = state.selectedColorLocation {
                colorTarget.frame.origin.x = colorLocation.x - colorTarget.frame.width / 2
                colorTarget.frame.origin.y = colorLocation.y - colorTarget.frame.height / 2
                colorTarget.fillColor = state.selectedColor.cgColor
            }
        }
    }
    
    override init(frame: CGRect) {
        state = ColorPickerState(color: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        state = ColorPickerState(color: UIColor(red: 1, green: 1, blue: 1, alpha: 1))
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        Bundle.main.loadNibNamed("ColorPickerView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    @IBAction func paletteOnTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: colorPaletteView)
        updateColor(paletteLocation: location)
    }
    
    @IBAction func palleteOnPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let location = gestureRecognizer.location(in: colorPaletteView)
        updateColor(paletteLocation: location)
    }
    
    @IBAction func brightnessValueChanged(_ sender: UISlider) {
        let brightness = brightnessSlider.value
        colorPaletteView.setBrightness(brightness)
        state.brightness = brightness
        
        if let location = state.selectedColorLocation {
            updateColor(paletteLocation: location)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorPaletteView.clipsToBounds = true
        
        paletteBorderView.layer.borderWidth = 2
        paletteBorderView.layer.borderColor = UIColor.black.cgColor
        
        if state.selectedColorLocation == nil {
            colorTarget.frame.origin.x = -100
            colorTarget.frame.origin.y = -100
        }
        
        currentColorView.setColor(state.selectedColor)
    }
    
    private func updateColor(paletteLocation: CGPoint) {
        var x = paletteLocation.x
        x = min(x, colorPaletteView.frame.width - 1)
        x = max(x, 0)
        var y = paletteLocation.y
        y = min(y, colorPaletteView.frame.height - 1)
        y = max(y, 0)
        
        guard let color = colorPaletteView.getColorAt(x: Int(x), y: Int(y)) else {
            DDLogError("Failed to get color from ColorPalette")
            return
        }
        
        state.selectedColorLocation = CGPoint(x: x, y: y)
        state.selectedColor = color
        currentColorView.setColor(color)
        
        if let selectedColorComponents = state.selectedColor.cgColor.components {
            colorTarget.fillColor = UIColor(
                red: selectedColorComponents[0],
                green: selectedColorComponents[1],
                blue: selectedColorComponents[2],
                alpha: 1).cgColor
        }
        colorTarget.frame.origin.x = x - colorTarget.frame.width / 2
        colorTarget.frame.origin.y = y - colorTarget.frame.height / 2
    }
}
