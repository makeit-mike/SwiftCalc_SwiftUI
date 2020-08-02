//
//  CalculatorFormatting.swift
//  Calculator
//
//  Created by Michael Jones on 8/1/20.
//  Copyright © 2020 MakeIt-Tech. All rights reserved.
//

import Foundation

class formatter{
    static func signChange(_ input: String) -> String {
        if !doStringContainsNumber(_string: input) ||
            input.lastIndex(where: { $0.isWholeNumber == false && $0 != "." }) == nil
        {return "-"+input}
        let indexOfSymbol = input.lastIndex(where: { $0.isWholeNumber == false && $0 != "." })!
        var endstr = String(input[indexOfSymbol...])
        if endstr.starts(with: "+") { endstr = endstr.replacingOccurrences(of: "+", with: "-")}
        else if endstr.starts(with: "-") { endstr = endstr.replacingOccurrences(of: "-", with: "+")}
        else {endstr.insert(contentsOf: "(-", at: endstr.index(endstr.startIndex, offsetBy: 1))}
        let returnStr = String(input[..<indexOfSymbol]) + endstr
        return returnStr
    }
    
    static func eval(_ input: String) -> String {
        //    let parser = MathParser()
        //    let expression = "cos(-0)"//"3123234×91243+7^3+32!÷16-asinh(cos(√(2,π+e)))"
        //    let start = NSDate.timeIntervalSinceReferenceDate
        //    let result = evaluateExpression(expression, MathParserAngleUnit.Degrees)
        //    let end = NSDate.timeIntervalSinceReferenceDate
        //
        //    let difference = Double(end) - Double(start)
        //
        //    var resultString: String
        //    if let unwrapedResult = result {
        //        if unwrapedResult == Double.infinity {
        //            resultString = "Math error"
        //        } else if unwrapedResult == -0.0 {
        //            resultString = "\(-unwrapedResult)"
        //            resultString = mathParserFormatNumber(resultString)
        //        } else {
        //            resultString = "\(unwrapedResult)"
        //            resultString = mathParserFormatNumber(resultString)
        //        }
        //    } else {
        //        resultString = "Syntax error"
        //    }
        
        if !doStringContainsNumber(_string: input) {return ""}
        var finalResult = input
        var inputString = input.replacingOccurrences(of: "÷", with: "/")
        inputString = inputString.replacingOccurrences(of: "×", with: "*")
        inputString = inputString.replacingOccurrences(of: ")(", with: ")*(")
        inputString = inputString.replacingOccurrences(of: ",", with: "")
        
        print("\n\n New Eval for \(inputString)")
        
        var countExponents = 0
        for char in inputString {
            if char == "^" {
                countExponents += 1
            }
        }
        
        
        for _ in 0..<countExponents{
            let symbol = inputString.firstIndex(of: "^")!
            let rightOfSymbol = inputString.index(symbol, offsetBy: 1)
            print(symbol)
            var leftStr = String(inputString[..<symbol])
            var rightStr = String(inputString[rightOfSymbol...])
            if rightStr.count == 0 {return ""}
            
            if doStringContainsNumber(_string: leftStr) && doStringContainsNumber(_string: rightStr){
                leftStr = String(leftStr.reversed())
                if(leftStr.hasPrefix(")")){
                    leftStr = String(leftStr[...leftStr.firstIndex(of: "(")!])
                }
                else{
                    leftStr = String(leftStr.prefix(while: {
                        ("0"..."9" ~= $0) ||
                            ("("...")" ~= $0) ||
                            ("." ~= $0)
                    }))
                }
                leftStr = String(leftStr.reversed())
                print("initial right string:",rightStr)
                if(rightStr.hasPrefix("(")){
                    rightStr = String(rightStr[...rightStr.firstIndex(of: ")")!])
                }
                else{
                    rightStr = String(rightStr.prefix(while: {
                        ("0"..."9" ~= $0) ||
                            ("("...")" ~= $0) ||
                            ("." ~= $0)
                    }))
                }
                print("L expr-",leftStr)
                if(leftStr.contains("(") && !leftStr.contains(")")){
                    leftStr = String(leftStr.removeFirst())
                }
                print(leftStr)
                if(rightStr.contains(")") && !rightStr.contains("(")){
                    rightStr = String(rightStr.dropLast())
                }
                print("R expr-", rightStr)
                let powerStr = String(leftStr + "^" + rightStr)
                print("power string \(powerStr)")
                do{
                    if(rightStr.count > 0){
                        leftStr = String(try Expression(leftStr).evaluate())
                        rightStr = String(try Expression(rightStr).evaluate())
                        print("final Lstr \(leftStr)")
                        print("final Rstr \(rightStr)")
                        print("input before: \(input)")
                        let powEval = try Expression("pow(\(leftStr),\(rightStr))").evaluate()
                        inputString = inputString.replacingOccurrences(of: powerStr, with: String(powEval))
                        print("power eval with input:  \(inputString)")
                    }
                    else {
                        print("Nothing to raise")
                        return ""
                    }
                    
                }catch{
                    print("error")
                    finalResult = input
                }
            }//end if loop
        }//end while loop
        do {
            let testExpression = Expression(inputString)
            let result = try testExpression.evaluate()
            let resultString:String = String(format: "%g", result)
            inputString = inputString.replacingOccurrences(of: "pow", with: "")
            inputString = inputString.replacingOccurrences(of: ",", with: "^")
            finalResult = resultString
            //finalResult = inputString+" = "+resultString
        } catch {
            print("error")
            finalResult = input
        }
        return finalResult
    }
    static func formatInput( current: String, button: String) -> String {
        if current == "" || current == " "  {
            print("triggered empty format, \(button)")
            return button
            
        }
        var cleanStr = current
        let lastChar = String(cleanStr.last!)
        print("\n Example: \(cleanStr)")
        let numCharSet = CharacterSet.init(charactersIn: "1234567890)(")
        if lastChar.rangeOfCharacter(from: numCharSet.inverted) != nil && button.rangeOfCharacter(from: numCharSet.inverted) != nil {
            print("last char is a sign")
        }
        else {
            print("last char is not a sign")
            cleanStr += button
        }
        
        return cleanStr
    }
    
    static func formatNumberThousands( _string: String) -> String {
        if _string == "" || _string == " " || _string.count < 4  {
            return _string
        }
        var safeStr = _string
        safeStr.removeAll(where: { $0 == "," })
        let numCharSet = CharacterSet.init(charactersIn: "1234567890.")
        let acceptableSigns = CharacterSet.init(charactersIn: "(-.")
        var numbers = safeStr.components(separatedBy: numCharSet.inverted)
        numbers.removeAll(where: { $0 == "" })
        var signs = safeStr.components(separatedBy: numCharSet)
        signs.removeAll(where: { $0 == "" || $0 == "."})
        var returnStr = ""
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        if signs.count == 0 {
            return String(formatter.string(for: Int(safeStr))!)
        }
        else if String(_string.first!).rangeOfCharacter(from: acceptableSigns) == nil{
            for i in 0..<numbers.count{
                if numbers[i].integer != nil {
                    returnStr += String(formatter.string(for: Int(numbers[i]))!)
                }else{ returnStr += numbers[i] }
                if i < signs.count {
                    returnStr += signs[i]
                }
            }
        }
        else {
            for i in 0..<signs.count{
                returnStr += signs[i]
                if i < numbers.count {
                    if numbers[i].integer != nil {
                        returnStr += String(formatter.string(for: Int(numbers[i]))!)
                    }else{ returnStr += numbers[i] }
                }
            }
        }
        print("formatted str: \(returnStr)")
        return returnStr
    }
    
    
    static func doStringContainsNumber( _string : String) -> Bool{
        let numberRegEx  = ".*[0-9]+.*"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let containsNumber = testCase.evaluate(with: _string)
        return containsNumber
    }
}
