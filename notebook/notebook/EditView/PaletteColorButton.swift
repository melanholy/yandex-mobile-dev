//
//  PaletteColorButton.swift
//  notebook
//
//  Created by Павел Кошара on 24/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CocoaLumberjack

class PaletteColorButton: ColorButton {
    private var colorPalette: ColorPalette? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.colorPalette = ColorPalette(
            width: Float(frame.width), height: Float(frame.height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.colorPalette = ColorPalette(
            width: Float(self.frame.width), height: Float(self.frame.height))
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        guard let image = colorPalette?.getImage() else {
            return
        }
        ctx.draw(image, in: self.bounds)
        
        super.draw(rect)
    }
}
