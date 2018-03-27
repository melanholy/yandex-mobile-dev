//
//  NoteCollectionViewCell.swift
//  notebook
//
//  Created by Павел Кошара on 24/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

@objc protocol NoteCollectionViewCellDeletgate {
    @objc optional func didTap(indexPath: IndexPath)
}

class NoteCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var colorSticker: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var editModeOverlay: UIView!
    
    public weak var delegate: NoteCollectionViewCellDeletgate?
    public var indexPath: IndexPath?
    
    public var label = "" {
        didSet {
            titleLabel.text = label
        }
    }
    public var text = "" {
        didSet {
            textLabel.text = text
        }
    }
    public var color = UIColor.white.cgColor {
        didSet {
            colorSticker.layer.backgroundColor = color
        }
    }
    public var editMode = false {
        didSet {
            editModeOverlay.isHidden = !editMode
        }
    }
    
    @IBAction private func overlayDidTap(_ sender: Any) {
        if let indexPath = indexPath {
            delegate?.didTap?(indexPath: indexPath)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorSticker.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .byTruncatingTail
        
        textLabel.adjustsFontSizeToFitWidth = false
        textLabel.lineBreakMode = .byTruncatingTail
        
        editModeOverlay.layer.backgroundColor = UIColor(
            red: 1, green: 0, blue: 0, alpha: 0.5).cgColor
    }
}
