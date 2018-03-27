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

    override func draw(_ rect: CGRect) {
        if color == nil {
            guard let ctx = UIGraphicsGetCurrentContext(),
                  let image = colorPalette?.getImage()else {
                return
            }
            ctx.draw(image, in: self.bounds)
        }
        
        super.draw(rect)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorPalette = ColorPalette(
            width: Float(self.frame.width), height: Float(self.frame.height))
    }
}
