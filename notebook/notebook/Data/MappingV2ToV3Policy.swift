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
import CocoaLumberjack

class MappingV2ToV3Policy: NSEntityMigrationPolicy {
    public func hexColorToUIColor(_ color: String) -> UIColor? {
        DDLogInfo("sdfsfs")
        return UIColor.parseFromHex(string: String(color))
    }
}
