//
//  CurrentColor.swift
//  notebook
//
//  Created by Павел Кошара on 19/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class CurrentColor: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var contentWrapper: UIView!
    @IBOutlet weak var hexColor: UILabel!
    
    private var selectedColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        Bundle.main.loadNibNamed("CurrentColor", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        contentWrapper.layer.borderWidth = 3
        contentWrapper.layer.borderColor = UIColor.black.cgColor
        contentWrapper.layer.cornerRadius = 13
        contentWrapper.clipsToBounds = true
        
        hexColor.layer.borderWidth = 1
        hexColor.layer.borderColor = UIColor.black.cgColor
        hexColor.backgroundColor = UIColor.white
        hexColor.font
        
        setColor(selectedColor)
    }
    
    func setColor(_ color: UIColor) {
        selectedColor = color
        
        guard let components = color.cgColor.components else {
            hexColor.text = "ERROR"
            return
        }
        
        if components.count != 4 {
            hexColor.text = "ERROR"
            return
        }
        
        let redByte = Int((components[0] * 255).rounded())
        let red = String(redByte, radix: 16)
        let greenByte = Int((components[1] * 255).rounded())
        let green = String(greenByte, radix: 16)
        let blueByte = Int((components[2] * 255).rounded())
        let blue = String(blueByte, radix: 16)
        
        hexColor.text = "#" + red + green + blue
        contentWrapper.backgroundColor = UIColor.black
    }
}
