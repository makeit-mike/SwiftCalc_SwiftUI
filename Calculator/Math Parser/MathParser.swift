//
//  MathParser.swift
//  Math Parser
//
//  Created by Vid Drobnic on 8/5/15.
//  Copyright (c) 2015 Vid Drobnic. All rights reserved.
//

import Foundation

func evaluateExpression(expression: String, angleUnit: MathParserAngleUnit) -> Double? {
    mathParserAngleUnits = angleUnit
    
    var buffer = ""
    var lastWasNumber = false
    var normalPriority = 0 //Affected by number of brackets
    
    var numbers = [Double]() //Parsed numbers
    var operations = [MathParserOperator]() //Parsed operators
    
    
    //MARK: Parsing to arrays
    mainLoop: for index in indices(expression) {
        let character = expression[index]
        
        if (character == "-" && index == expression.startIndex) || (character == "-" && expression[index.predecessor()] == "(") {
            var operation = Negation()
            operation.priority += normalPriority
            operation.startIndex = numbers.count
            operations.append(operation)
            continue
        }
        
        if lastWasNumber && character.isNumber {
            buffer.append(character)
        } else if !lastWasNumber && !character.isNumber {
            switch character {
            case "(": //Each time a bracket is found buffer is force parsed
                if !buffer.isEmpty {
                    if mathParserConstants.numberOfKeysStartingWith(buffer) > 0 {
                        if let constant = mathParserConstants[buffer] {
                            numbers.append(constant.value)
                        }
                    } else if mathParserOperators.numberOfKeysStartingWith(buffer) > 0 {
                        if mathParserOperators[buffer] != nil {
                            var operation = mathParserOperators[buffer]!
                            operation.priority += normalPriority
                            
                            if operation.type == .Infix || operation.type == .Suffix {
                                operation.startIndex = numbers.count - 1
                            } else {
                                operation.startIndex = numbers.count
                            }
                            
                            operations.append(operation)
                        }
                    } else {
                        return nil
                    }
                }
                buffer = ""
                
                normalPriority += mathParserBracketPriority
                continue
            case ")":
                if !buffer.isEmpty {
                    if mathParserConstants.numberOfKeysStartingWith(buffer) > 0 {
                        if let constant = mathParserConstants[bufer] {
                            numbers.append(constant.value)
                        }
                    } else if mathParserOperators.numberOfKeysStartingWith(buffer) > 0 {
                        if mathParserOperators[buffer] != nil {
                            var operation = mathParserOperators[buffer]!
                            operation.priority += normalPriority
                            
                            if operation.type == .Infix || operation.type == .Suffix {
                                operation.startIndex = numbers.count - 1
                            } else {
                                operation.startIndex = numbers.count
                            }
                            
                            operations.append(operation)
                        }
                    } else {
                        return nil
                    }
                }
                
                buffer = ""
                
                normalPriority -= mathParserBracketPriority
                continue
            default:
                break
            }
            
            buffer.append(character)
            
            if mathParserConstants.numberOfKeysStartingWith(buffer) == 1 {
                if let constant = mathParserConstants[buffer] {
                    numbers.append(constant.value)
                    lastWasNumber = true
                    buffer = ""
                }
            } else if mathParserOperators.numberOfKeysStartingWith(buffer) == 1 {
                if mathParserOperators[buffer] != nil {
                    var operation =  mathParserOperators[buffer]!
                    operation.priority += normalPriority
                    
                    if operation.type == .Infix || operation.type == .Suffix {
                        operation.startIndex = numbers.count - 1
                    } else {
                        operation.startIndex = numbers.count
                    }
                    
                    operations.append(operation)
                    buffer = ""
                }
            }
        } else if !lastWasNumber && character.isNumber {
            if !buffer.isEmpty {
                if mathParserConstants.numberOfKeysStartingWith(buffer) > 0 {
                    if let constant = mathParserConstants[buffer] {
                        numbers.append(constant.value)
                    }
                } else if mathParserOperators.numberOfKeysStartingWith(buffer) > 0 {
                    if mathParserOperators[buffer] != nil {
                        var operation = mathParserOperators[buffer]!
                        operation.priority += normalPriority
                        
                        if operation.type == .Infix || operation.type == .Suffix {
                            operation.startIndex = numbers.count - 1
                        } else {
                            operation.startIndex = numbers.count
                        }
                        
                        operations.append(operation)
                    }
                } else {
                    return nil
                }
            }
            
            buffer = ""
            buffer.append(character)
            lastWasNumber = true
        } else if lastWasNumber && !character.isNumber {
            if !buffer.isEmpty {
                numbers.append(buffer.toDouble()!)
                buffer = ""
            }
            
            switch character {
            case "(":
                var operation = Multiplication()
                operation.priority += normalPriority
                operation.startIndex = numbers.count - 1
                operations.append(operation)
                
                normalPriority += mathParserBracketPriority
                continue
            case ")":
                normalPriority -= mathParserBracketPriority
                continue
            case ",":
                continue
            default:
                break
            }
            
            lastWasNumber = false
            
            buffer.append(character)
            
            if mathParserConstants.numberOfKeysStartingWith(buffer) == 1 {
                if let constant = mathParserConstants[buffer] {
                    numbers.append(constant.value)
                    lastWasNumber = true
                    buffer = ""
                }
            } else if mathParserOperators.numberOfKeysStartingWith(buffer) == 1 {
                if mathParserOperators[buffer] != nil {
                    var operation =  mathParserOperators[buffer]!
                    operation.priority += normalPriority
                    
                    if operation.type == .Infix || operation.type == .Suffix {
                        operation.startIndex = numbers.count - 1
                    } else {
                        operation.startIndex = numbers.count
                    }
                    
                    operations.append(operation)
                    buffer = ""
                }
            }
        }
    }
    
    if !buffer.isEmpty {
        if let number = buffer.toDouble() {
            numbers.append(number)
        } else if mathParserConstants.numberOfKeysStartingWith(buffer) > 0 {
            if let constant = mathParserConstants[buffer] {
                numbers.append(constant.value)
            }
        } else if mathParserOperators.numberOfKeysStartingWith(buffer) > 0 {
            if mathParserOperators[buffer] != nil {
                var operation = mathParserOperators[buffer]!
                operation.priority += normalPriority
                
                if operation.type == .Infix || operation.type == .Suffix {
                    operation.startIndex = numbers.count - 1
                } else {
                    operation.startIndex = numbers.count
                }
                
                operations.append(operation)
            }
        } else {
            return nil
        }
    }
    
    if normalPriority != 0 {
        return nil
    }
    
    
    //MARK: Parsing arrays
    
    while operations.count > 0 {
        var maxPriority = 0
        var maxPriorityIndex = -1
        
        for i in 0..<operations.count {
            if operations[i].priority > maxPriority {
                maxPriority = operations[i].priority
                maxPriorityIndex = i
            }
        }
        
        let operation = operations[maxPriorityIndex]
        let startIndex = operation.startIndex
        if startIndex < 0 || startIndex >= numbers.count || (startIndex + operation.length - 1) >= numbers.count {
            return nil
        }
        
        var numbersToEvaluate = [numbers[startIndex]]
        
        for i in 1..<operation.length {
            numbersToEvaluate.append(numbers[startIndex + i])
        }
        
        numbers[startIndex] = operation.evaluate(numbersToEvaluate)
        
        for i in 1..<operation.length {
            numbers.removeAtIndex(startIndex + 1)
        }
        
        operations.removeAtIndex(maxPriorityIndex)
        
        let toRemove = operation.length - 1
        if toRemove > 0 {
            for i in maxPriorityIndex..<operations.count {
                operations[i].startIndex -= toRemove
            }
        }
    }
    
    if numbers.count == 1 {
        if numbers[0] == -0.0 {
            return -numbers[0]
        } else {
            return numbers[0]
        }
    } else {
        return nil
    }
}
