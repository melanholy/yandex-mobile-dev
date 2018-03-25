//
//  ViewController.swift
//  notebook
//
//  Created by user on 07.03.18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var editView: EditView! {
        didSet {
            editView.delegate = self
        }
    }
    @IBOutlet weak var colorPickerView: ColorPickerView! {
        didSet {
            colorPickerView.delegate = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func unwindToEditView(segue: UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}

extension ViewController: EditViewDelegate {
    func showColorPicker() {
        performSegue(withIdentifier: "showColorPickerView", sender: self)
    }
}

extension ViewController: ColorPickerViewDeletegate {
    func close(selectedColor: UIColor) {
        performSegue(withIdentifier: "unwindToEditView", sender: self)
    }
}
