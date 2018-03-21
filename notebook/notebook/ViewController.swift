//
//  ViewController.swift
//  notebook
//
//  Created by user on 07.03.18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var editView: EditView! {
        didSet {
            editView.delegate = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}

extension ViewController : EditViewDelegate {
    func showColorPicker() {
        //self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
    }
}
