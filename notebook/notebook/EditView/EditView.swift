//
//  EditController.swift
//  notebook
//
//  Created by Павел Кошара on 18/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CocoaLumberjack

private let datePickerHeight: CGFloat = 150

@objc protocol EditViewDelegate : class {
    @objc optional func showColorPicker()
}

class EditView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var destroyDateSwitch: UISwitch!
    @IBOutlet private weak var noteNameTextField: UITextField!
    @IBOutlet private weak var noteContentTextView: UITextView!
    @IBOutlet private weak var contentTextHeight: NSLayoutConstraint!
    @IBOutlet private weak var mainScrollView: UIScrollView!
    @IBOutlet private weak var colorsStackView: UIStackView!
    @IBOutlet private weak var datePickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var colorButtons: [ColorButton]!
    @IBOutlet weak var destroyDatePicker: UIDatePicker!
    
    public weak var delegate: EditViewDelegate? = nil
    
    private var keyboardHeight: CGFloat = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    @IBAction func useDestroyDateDidChange() {
        datePickerHeightConstraint.constant = destroyDateSwitch.isOn ? datePickerHeight : 0
    }
    
    @IBAction func colorDidTap(_ sender: ColorButton) {
        colorButtons.forEach { $0.selectedColor = false }
        sender.selectedColor = true
    }
    
    @IBAction func longPressOnColorPicker(_ sender: UILongPressGestureRecognizer) {
        if (sender.state == .began) {
            delegate?.showColorPicker?()
        }
    }
    
    public func getNote() -> Note? {
        guard let title = noteNameTextField.text,
            let content = noteContentTextView.text,
            let color = colorButtons.first(where: { $0.selectedColor })?.color else {
                return nil
        }
        
        return Note(
            title: title,
            content: content,
            color: color,
            importance: Importance.common,
            relevantTo: destroyDateSwitch.isOn ? destroyDatePicker.date : nil)
    }
    
    public func setNote(_ note: Note) {
        noteNameTextField.text = note.title
        noteContentTextView.text = note.content
        if let destroyDate = note.relevantTo {
            destroyDateSwitch.isOn = true
            destroyDatePicker.date = destroyDate
        }
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("EditView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func resizeContent() {
        let sz = noteContentTextView.systemLayoutSizeFitting(CGSize(width: bounds.size.width, height: UILayoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        contentTextHeight.constant = sz.height // noteContentTextView.frame.height
        setNeedsUpdateConstraints()
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
        colorButtons[0].selectedColor = true
    }
}

extension EditView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteNameTextField.endEditing(true)
        return false
    }
}

extension EditView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        resizeContent()
    }
}
