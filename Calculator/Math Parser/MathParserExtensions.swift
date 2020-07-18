//
//  MathParserExtensions.swift
//  Math Parser
//
//  Created by Vid Drobnic on 8/5/15.
//  Copyright (c) 2015 Vid Drobnic. All rights reserved.
//

import Foundation

extension String {
    func toDouble() -> Double? {
        return NSString(string: self).doubleValue
    }
}

extension Character {
    var isNumber: Bool {
        get {
            switch self {
            case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ".":
                return true
            default:
                return false
            }
        }
    }
}

extension Dictionary {
    func numberOfKeysStartingWith(searchString: String) -> Int? {
        var count = 0
        
        for key in keys {
            if !(key is String) {
                return nil
            }
            
            if (key as! String).hasPrefix(searchString) {
                ++count
            }
        }
        return count
    }
}

func radianToDegree(radian: Double) -> Double {
    return radian / M_PI * 180.0
}

func degreeToRadian(degree: Double) -> Double {
    return degree / 180.0 * M_PI
}