//
//  ColorPalette.swift
//  notebook
//
//  Created by Павел Кошара on 19/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CocoaLumberjack

class ColorPalette: UIButton {
    private var pixelData: [Float]? = nil
    private var brightness: Float = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setBrightess(_ brightness: Float) {
        self.brightness = brightness
        setNeedsDisplay()
    }
    
    public func getColorAt(x: Int, y: Int) -> UIColor? {
        if let pixelData = pixelData {
            let width = Int(self.frame.width)
            let origin = pixelData.count - (width * (y + 1) - x) * 4
            return UIColor(
                red: CGFloat(pixelData[origin]),
                green: CGFloat(pixelData[origin + 1]),
                blue: CGFloat(pixelData[origin + 2]),
                alpha: CGFloat(pixelData[origin + 3]))
        } else {
            DDLogError("ColorPalette.getColorAt was called with nil pixelData")
            return nil
        }
    }
    
    private func getPixelDataWith(brightness: Float) -> [Float] {
        let width = Int(self.frame.width)
        let height = Int(self.frame.height)
        
        var data = [Float]()
        data.reserveCapacity(width * height * 4)
        let alphaStep = 1 / Float(self.frame.height)
        let colorStep = 1 / (Float(self.frame.width) / 6)
        var currentAlpha: Float = 0
        while currentAlpha < 1 {
            var red: Float = 1
            var green: Float = 0
            var blue: Float = 0
            while green + colorStep < 1 {
                data.append(currentAlpha * brightness)
                data.append(green * currentAlpha * brightness)
                data.append(0)
                data.append(currentAlpha)
                
                green += colorStep
            }
            green = 1
            while red - colorStep > 0 {
                data.append(red * currentAlpha * brightness)
                data.append(currentAlpha * brightness)
                data.append(0)
                data.append(currentAlpha)
                
                red -= colorStep
            }
            red = 0
            while blue + colorStep < 1 {
                data.append(0)
                data.append(currentAlpha * brightness)
                data.append(blue * currentAlpha * brightness)
                data.append(currentAlpha)
                
                blue += colorStep
            }
            blue = 1
            while green - colorStep > 0 {
                data.append(0)
                data.append(green * currentAlpha * brightness)
                data.append(currentAlpha * brightness)
                data.append(currentAlpha)
                
                green -= colorStep
            }
            green = 0
            while red + colorStep < 1 {
                data.append(red * currentAlpha * brightness)
                data.append(0)
                data.append(currentAlpha * brightness)
                data.append(currentAlpha)
                
                red += colorStep
            }
            red = 1
            while blue - colorStep > 0 {
                data.append(1 * currentAlpha * brightness)
                data.append(0)
                data.append(blue * currentAlpha * brightness)
                data.append(currentAlpha)
                
                blue -= colorStep
            }
            while ((data.count / 4) % width != 0) {
                data.append(0)
            }
            currentAlpha += alphaStep
        }
        
        return data
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            DDLogError("Failed to get current CGContext in ColorPalette.draw")
            return
        }
        
        let data = getPixelDataWith(brightness: brightness)
        pixelData = data
        
        let width = Int(self.frame.width)
        let height = Int(self.frame.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        guard let bitmapContext = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 32,
            bytesPerRow: 16 * width,
            space: colorSpace,
            bitmapInfo: CGBitmapInfo.floatComponents.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue) else {
                DDLogError("Failed to create CGContext in ColorPalette.draw")
                return
        }
        
        guard let bitmapData = bitmapContext.data?.assumingMemoryBound(to: Float.self) else {
            DDLogError("CGContext didn't have data in ColorPalette.draw")
            return
        }
        bitmapData.assign(from: UnsafePointer<Float>(data), count: width * height * 4)

        guard let image = bitmapContext.makeImage() else {
            DDLogError("Failed to get image from CGContext in ColorPalette.draw")
            return
        }
        
        ctx.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
    }
}
