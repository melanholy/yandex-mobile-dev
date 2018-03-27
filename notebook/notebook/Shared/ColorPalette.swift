//
//  ColorPalette.swift
//  notebook
//
//  Created by Павел Кошара on 19/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CocoaLumberjack

class ColorPalette {
    private var pixelData: [Float] = [Float]()
    private var brightness: Float = 1
    private var imageCache: CGImage? = nil
    private var lastBrightness: Float = -1
    private let width: Float
    private let height: Float
    
    init(width: Float, height: Float) {
        self.width = width
        self.height = height
        pixelData = getPixelDataWith(brightness: brightness)
    }
    
    public func setBrightess(_ brightness: Float) {
        pixelData = getPixelDataWith(brightness: brightness)
        lastBrightness = brightness
    }
    
    public func getColorAt(x: Int, y: Int) -> UIColor? {
        let width = Int(self.width)
        let origin = pixelData.count - (width * (y + 1) - x) * 4
        let alpha = pixelData[origin + 3]
        let whiteComponent = 1 * (1 - alpha)
        return UIColor(
            red: CGFloat(pixelData[origin] + whiteComponent),
            green: CGFloat(pixelData[origin + 1] + whiteComponent),
            blue: CGFloat(pixelData[origin + 2] + whiteComponent),
            alpha: CGFloat(alpha))
    }
    
    public func getImage() -> CGImage? {
        if let imageCache = imageCache, lastBrightness == brightness {
            return imageCache
        }
    
        let width = Int(self.width)
        let height = Int(self.height)
        
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
                return nil
        }
        
        guard let bitmapData = bitmapContext.data?.assumingMemoryBound(to: Float.self) else {
            DDLogError("CGContext didn't have data in ColorPalette.draw")
            return nil
        }
        bitmapData.assign(from: UnsafePointer<Float>(pixelData), count: width * height * 4)
        
        guard let image = bitmapContext.makeImage() else {
            DDLogError("Failed to get image from CGContext in ColorPalette.draw")
            return nil
        }
        
        imageCache = image
        lastBrightness = brightness
        
        return image
    }
    
    private func getPixelDataWith(brightness: Float) -> [Float] {
        let width = Int(self.width)
        let height = Int(self.height)
        
        var data = [Float]()
        data.reserveCapacity(width * height * 4)
        let alphaStep = 1 / self.height
        let colorStep = 1 / (self.width / 6)
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
}
