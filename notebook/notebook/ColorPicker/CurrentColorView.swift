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
        
        contentWrapper.backgroundColor = color
        
        if let hexString = color.toHexString() {
            hexColor.text = hexString
        } else {
            hexColor.text = "ERROR"
        }
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
