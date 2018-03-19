//
//  Extensions.swift
//  notebook
//
//  Created by Павел Кошара on 18/03/2018.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

extension CGPoint {
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
}
