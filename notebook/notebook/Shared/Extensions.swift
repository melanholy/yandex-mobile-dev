//
//  Extensions.swift
//  notebook
//
//  Created by Павел Кошара on 09/04/2018.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension UIImage {
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

extension UIColor {
    func toHexString() -> String? {
        guard let components = cgColor.components,
            components.count == 4 else {
            return nil
        }
        
        let redByte = Int((components[0] * 255).rounded())
        let red = String(format: "%02X", redByte)
        let greenByte = Int((components[1] * 255).rounded())
        let green = String(format: "%02X", greenByte)
        let blueByte = Int((components[2] * 255).rounded())
        let blue = String(format: "%02X", blueByte)
        
        return "#\(red)\(green)\(blue)"
    }
    
    static func parseFromHex(string: String) -> UIColor? {
        guard string.count == 7,
            string.prefix(1) == "#",
            let value = Int(string.suffix(6), radix: 16) else {
                return nil
        }
        
        return UIColor(
            red: CGFloat((value & 0xff0000) >> 16) / 255,
            green: CGFloat((value & 0xff00) >> 8) / 255,
            blue: CGFloat(value & 0xff) / 255,
            alpha: 1)
    }
}

class InvalidFetchError: LocalizedError {
    public var errorDescription: String? { return message }
    
    private let message: String
    
    init(_ message: String) {
        self.message = message
    }
}

extension NSManagedObjectContext {
    func fetchSingle<T>(_ request: NSFetchRequest<T>) throws -> T {
        let fetchResult = try fetch(request)
        guard fetchResult.count == 1 else {
            throw InvalidFetchError("NSManagedObjectContext didn't returned single element")
        }
        
        return fetchResult[0]
    }
    
    func fetchFirst<T>(_ request: NSFetchRequest<T>) throws -> T? {
        let fetchResult = try fetch(request)
        
        return fetchResult.first
    }
}
