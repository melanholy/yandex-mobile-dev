//
//  ColorPalette.swift
//  notebook
//
//  Created by Павел Кошара on 19/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ColorPalette: UIButton {
    private var brightness: Float = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func setBrightess(_ brightness: Float) {
        self.brightness = brightness
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let width = Int(self.frame.width - 4)
        let height = Int(self.frame.height - 4)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapContext = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 32,
            bytesPerRow: 16 * width,
            space: colorSpace,
            bitmapInfo: CGBitmapInfo.floatComponents.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue)!
        let data = bitmapContext.data!.assumingMemoryBound(to: Float.self)
        
        let alphaStep = 1 / Float(self.frame.height - 4)
        let colorStep = 1 / (Float(self.frame.width - 4) / 6)
        var index = 0
        var currentAlpha: Float = 0
        while currentAlpha < 1 {
            var red: Float = 1
            var green: Float = 0
            var blue: Float = 0
            while green + colorStep < 1 {
                data[index] = 1 * currentAlpha * brightness
                data[index + 1] = green * currentAlpha * brightness
                data[index + 2] = 0
                data[index + 3] = currentAlpha
                
                green += colorStep
                index += 4
            }
            green = 1
            while red - colorStep > 0 {
                data[index] = red * currentAlpha * brightness
                data[index + 1] = 1 * currentAlpha * brightness
                data[index + 2] = 0
                data[index + 3] = currentAlpha
                
                red -= colorStep
                index += 4
            }
            red = 0
            while blue + colorStep < 1 {
                data[index] = 0
                data[index + 1] = 1 * currentAlpha * brightness
                data[index + 2] = blue * currentAlpha * brightness
                data[index + 3] = currentAlpha
                
                blue += colorStep
                index += 4
            }
            blue = 1
            while green - colorStep > 0 {
                data[index] = 0
                data[index + 1] = green * currentAlpha * brightness
                data[index + 2] = 1 * currentAlpha * brightness
                data[index + 3] = currentAlpha
                
                green -= colorStep
                index += 4
            }
            green = 0
            while red + colorStep < 1 {
                data[index] = red * currentAlpha * brightness
                data[index + 1] = 0
                data[index + 2] = 1 * currentAlpha * brightness
                data[index + 3] = currentAlpha
                
                red += colorStep
                index += 4
            }
            red = 1
            while blue - colorStep > 0 {
                data[index] = 1 * currentAlpha * brightness
                data[index + 1] = 0
                data[index + 2] = blue * currentAlpha * brightness
                data[index + 3] = currentAlpha
                
                blue -= colorStep
                index += 4
            }
            
            while ((index / 4) % width != 0) {
                index += 4
            }
            currentAlpha += alphaStep
        }
        
        ctx.draw(bitmapContext.makeImage()!, in: CGRect(x: 2, y: 2, width: width, height: height))
    }
}
