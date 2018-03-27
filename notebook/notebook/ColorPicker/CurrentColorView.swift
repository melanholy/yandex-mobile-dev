//
//  CurrentColor.swift
//  notebook
//
//  Created by Павел Кошара on 19/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class CurrentColorView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var contentWrapper: UIView!
    @IBOutlet private weak var hexColor: UILabel!
    
    private var selectedColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    public func setColor(_ color: UIColor) {
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
        let red = String(format: "%02X", redByte)
        let greenByte = Int((components[1] * 255).rounded())
        let green = String(format: "%02X", greenByte)
        let blueByte = Int((components[2] * 255).rounded())
        let blue = String(format: "%02X", blueByte)
        
        hexColor.text = "#" + red + green + blue
        contentWrapper.backgroundColor = color
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentWrapper.layer.borderWidth = 3
        contentWrapper.layer.borderColor = UIColor.black.cgColor
        contentWrapper.layer.cornerRadius = 13
        contentWrapper.clipsToBounds = true
        
        hexColor.layer.borderWidth = 1
        hexColor.layer.borderColor = UIColor.black.cgColor
        hexColor.backgroundColor = UIColor.white
        
        setColor(selectedColor)
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("CurrentColor", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
    }
}
