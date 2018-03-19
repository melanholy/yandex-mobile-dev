//
//  ColorPickerView.swift
//  notebook
//
//  Created by Павел Кошара on 19/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ColorPickerView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var colorPalette: ColorPalette!
    @IBOutlet weak var brightnessSlider: UISlider!
    
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
    }
    
    @IBAction func brightnessValueChanged(_ sender: UISlider) {
        colorPalette.setBrightess(brightnessSlider.value)
    }
}
