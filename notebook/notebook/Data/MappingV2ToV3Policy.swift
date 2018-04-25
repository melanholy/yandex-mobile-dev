//
//  MappingV2ToV3Policy.swift
//  notebook
//
//  Created by Павел Кошара on 22/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MappingV2ToV3Policy: NSEntityMigrationPolicy {
    func hexColorToUIColor(_ strColor: String) -> UIColor? {
        return UIColor.parseFromHex(string: strColor)
    }
}
