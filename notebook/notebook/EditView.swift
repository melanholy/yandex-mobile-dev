//
//  EditController.swift
//  notebook
//
//  Created by Павел Кошара on 18/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CocoaLumberjack

class EditView: UIView, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var destroyDateSwitch: UISwitch!
    @IBOutlet weak var noteNameTextField: UITextField!
    @IBOutlet weak var noteContentTextView: UITextView!
    @IBOutlet weak var contentTextHeight: NSLayoutConstraint!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var colorsStackView: UIStackView!
    @IBOutlet weak var colorPickerGestureRecognizer: UILongPressGestureRecognizer!
    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var colorButtons: [ColorButton]!
    @IBOutlet weak var colorPaletteButton: ColorPalette!
    @IBOutlet weak var paletteButtonBorder: UIView!
    
    var keyboardHeight: CGFloat = -1
    let screenSize = UIScreen.main.bounds
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        Bundle.main.loadNibNamed("EditView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        paletteButtonBorder.layer.borderColor = UIColor.black.cgColor
        paletteButtonBorder.layer.borderWidth = 2
    }
    
    @IBAction func useDestroyDateDidChange() {
        datePickerHeightConstraint.constant = destroyDateSwitch.isOn ? datePickerHeight : 0
    }
    
    @IBAction func colorDidTap(_ sender: ColorButton) {
        colorButtons.forEach { $0.deselect() }
        sender.select()
    }
    
    @IBAction func longPressOnColorPicker(_ sender: UILongPressGestureRecognizer) {
        
    }
    
    func resizeContent() {
        noteContentTextView.sizeToFit()
        contentTextHeight.constant = noteContentTextView.frame.height
        setNeedsUpdateConstraints()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteNameTextField.endEditing(true)
        return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        resizeContent()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
        }
    }
    
    override func awakeFromNib() {
        noteNameTextField.delegate = self
        noteContentTextView.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: .UIKeyboardWillShow,
            object: nil)
        
        resizeContent()
        datePickerHeightConstraint.constant = destroyDateSwitch.isOn ? datePickerHeight : 0
        colorButtons[0].select()
    }
}

private let datePickerHeight: CGFloat = 150
