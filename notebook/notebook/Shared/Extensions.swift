//
//  Extensions.swift
//  notebook
//
//  Created by Павел Кошара on 09/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    convenience init?(view: UIView, in rect: CGRect) {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        view.drawHierarchy(
            in: CGRect(
                x: -rect.origin.x,
                y: -rect.origin.y,
                width: view.bounds.width,
                height: view.bounds.height),
            afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        self.init(cgImage: image)
    }
}
