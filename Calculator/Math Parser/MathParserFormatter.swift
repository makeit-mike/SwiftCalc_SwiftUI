//
//  MathParserFormatter.swift
//  Math Parser
//
//  Created by Vid Drobnic on 8/9/15.
//  Copyright (c) 2015 Vid Drobnic. All rights reserved.
//

import Foundation

let mathParserDecimalSeparator = NSLocale.currentLocale().objectForKey(NSLocaleDecimalSeparator) as! String
var mathParserNumberSeparator: String {
    get {
        if mathParserDecimalSeparator == "." {
            return ","
        } else {
            return "."
        }
    }
}

func mathParserFormatNumber(number: String) -> String {
    var mutatableNumber = number.stringByReplacingOccurrencesOfString(".", withString: mathParserDecimalSeparator, options: NSStringCompareOptions.LiteralSearch, range: nil)
    var decimalSeparatorFound = false
    
    if mutatableNumber.rangeOfString(mathParserDecimalSeparator, options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil) == nil {
        decimalSeparatorFound = true
    }
    
    var count = 0
    
    for var index = mutatableNumber.endIndex.predecessor(); index > mutatableNumber.startIndex; index = index.predecessor() {
        if mutatableNumber[index] == Character(mathParserDecimalSeparator) {
            decimalSeparatorFound = true
            continue
        } else if !decimalSeparatorFound {
            continue
        }
        
        if count == 2 {
            mutatableNumber.splice(mathParserNumberSeparator, atIndex: index)
            count = 0
            continue
        }
        
        ++count
    }
    
    return mutatableNumber
}

func mathParserFormatExpression(expression: String) -> String {
    var mutableExpression = expression.stringByReplacingOccurrencesOfString(",", withString: "; ", options: NSStringCompareOptions.LiteralSearch, range: nil)
    
    var result = ""
    var currentNumber = ""
    
    for character in mutableExpression {
        if character.isNumber {
            currentNumber.append(character)
        } else if !currentNumber.isEmpty {
            result += mathParserFormatNumber(currentNumber)
            currentNumber = ""
            result.append(character)
        } else {
            result.append(character)
        }
    }
    
    if !currentNumber.isEmpty {
        result += mathParserFormatNumber(currentNumber)
    }
    
    return result
}