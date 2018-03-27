//
//  ColorPickerViewController.swift
//  notebook
//
//  Created by Павел Кошара on 25/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {
    @IBOutlet private weak var colorPickerView: ColorPickerView! {
        didSet {
            if let selectedColor = selectedColor {
                colorPickerView.currentColor = selectedColor
            }
        }
    }
    
    public var selectedColor: UIColor? = nil
    
    @IBAction func dismissDidTap(_ sender: Any) {
        selectedColor = colorPickerView.currentColor
    }
}
