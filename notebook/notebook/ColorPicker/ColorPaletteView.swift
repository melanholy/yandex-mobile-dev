//
//  ColorPaletteView.swift
//  notebook
//
//  Created by Павел Кошара on 25/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CocoaLumberjack

class ColorPaletteView: UIView {
    private var colorPalette: ColorPalette?
    private var currentBrightness: Float?
    
    public func setBrightness(_ brightness: Float) {
        currentBrightness = brightness
        colorPalette?.setBrightess(brightness)
        setNeedsDisplay()
    }
    
    public func getColorAt(x: Int, y: Int) -> UIColor? {
        return colorPalette?.getColorAt(x: x, y: y)
    }
    
    override func layoutSubviews() {
        colorPalette = ColorPalette(
            width: Float(frame.width),
            height: Float(frame.height))
        if let brightness = currentBrightness {
            colorPalette?.setBrightess(brightness)
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            DDLogError("Failed to get current CGContext in ColorPaletteView.draw")
            return
        }
        
        guard let palette = colorPalette?.getImage() else {
            return
        }
        
        ctx.draw(palette, in: CGRect(
            x: 0,
            y: 0,
            width: frame.width,
            height: frame.height))
    }
}
