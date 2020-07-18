//
//  VDDMathParserOperators.swift
//  Math Parser
//
//  Created by Vid Drobnic on 8/4/15.
//  Copyright (c) 2015 Vid Drobnic. All rights reserved.
//

import Foundation


//MARK: Enum declaration
enum MathParserOperationType {
    case Prefix, Infix, Suffix
}

enum MathParserAngleUnit {
    case Radians, Degrees
}


//MARK: Protocol Declaration
protocol MathParserOperator {
    var type: MathParserOperationType {get}
    var priority: Int {get set}
    var startIndex: Int {get set}
    var length: Int {get}
    
    func evaluate(numbers: [Double]) -> Double
}


//MARK: Type Declarations

struct Addition: MathParserOperator {
    var type = MathParserOperationType.Infix
    var priority = 1
    var startIndex = -1
    var length = 2
    
    func evaluate(numbers: [Double]) -> Double {
        return numbers[0] + numbers[1]
    }
}

struct Subtraction: MathParserOperator {
    var type = MathParserOperationType.Infix
    var priority = 1
    var startIndex = -1
    var length = 2
    
    func evaluate(numbers: [Double]) -> Double {
        return numbers[0] - numbers[1]
    }
}

struct Multiplication: MathParserOperator {
    var type = MathParserOperationType.Infix
    var priority = 2
    var startIndex = -1
    var length = 2
    
    func evaluate(numbers: [Double]) -> Double {
        return numbers[0] * numbers[1]
    }
}

struct Division: MathParserOperator {
    var type = MathParserOperationType.Infix
    var priority = 2
    var startIndex = -1
    var length = 2
    
    func evaluate(numbers: [Double]) -> Double {
        return numbers[0] / numbers[1]
    }
}

struct Negation: MathParserOperator {
    var type = MathParserOperationType.Prefix
    var priority = 2
    var startIndex = -1
    var length = 1
    
    func evaluate(numbers: [Double]) -> Double {
        return -numbers[0]
    }
}

struct Power: MathParserOperator {
    var type = MathParserOperationType.Infix
    var priority = 3
    var startIndex = -1
    var length = 2
    
    func evaluate(numbers: [Double]) -> Double {
        return pow(numbers[0], numbers[1])
    }
}

struct Root: MathParserOperator {
    var type = MathParserOperationType.Prefix
    var priority = 4
    var startIndex = -1
    var length = 2
    
    func evaluate(numbers: [Double]) -> Double {
        return pow(numbers[1], 1.0 / numbers[0])
    }
}

struct Logarithm: MathParserOperator {
    var type = MathParserOperationType.Prefix
    var priority = 4
    var startIndex = -1
    var length = 2
    
    func evaluate(numbers: [Double]) -> Double {
        if numbers[0] <= 0 {
            return Double.infinity
        }
        return log10(numbers[1]) / log10(numbers[0])
    }
}

struct Factorial: MathParserOperator {
    var type = MathParserOperationType.Suffix
    var priority = 4
    var startIndex = -1
    var length = 1
    
    func evaluate(numbers: [Double]) -> Double {
        let number = numbers[0]
        
        if number > 170 || number < 1 || number != Double(Int(number)) {
            return Double.infinity
        }
        
        var result: Double = 1
        for i in 1...Int(number) {
            result *= Double(i)
        }
        
        return result
    }
}

struct Percentage: MathParserOperator {
    var type = MathParserOperationType.Suffix
    var priority = 4
    var startIndex = -1
    var length = 1
    
    func evaluate(numbers: [Double]) -> Double {
        return numbers[0] / 100.0
    }
}

struct Sin: MathParserOperator {
    var type = MathParserOperationType.Prefix
    var priority = 5
    var startIndex = -1
    var length = 1
    
    func evaluate(numbers: [Double]) -> Double {
        let number = numbers[0]
        
        var result: Double
        
        switch mathParserAngleUnits {
        case .Radians:
            result = sin(number)
        case .Degrees:
            result = sin(degreeToRadian(number))
        }
        
        if abs(abs(round(result)) - abs(result)) < mathParserPrecision {
            result = round(result)
        }
        
        if result == -0.0 {
            return -result
        }
        
        return result
    }
}

struct Cos: MathParserOperator {
    var type = MathParserOperationType.Prefix
    var priority = 5
    var startIndex = -1
    var length = 1
    
    func evaluate(numbers: [Double]) -> Double {
        let number = numbers[0]
        
        var result: Double
        
        switch mathParserAngleUnits {
        case .Radians:
            result =  cos(number)
        case .Degrees:
            result =  cos(degreeToRadian(number))
        }
        
        if abs(abs(round(result)) - abs(result)) < mathParserPrecision {
            result = round(result)
        }
        
        if result == -0.0 {
            return -result
        }
        
        return result
    }
}

struct Tan: MathParserOperator {
    var type = MathParserOperationType.Prefix
    var priority = 5
    var startIndex = -1
    var length = 1
    
    func evaluate(numbers: [Double]) -> Double {
        let number = numbers[0]
        
        var result: Double
        
        switch mathParserAngleUnits {
        case .Radians:
            result =  tan(number)
        case .Degrees:
            result =  tan(degreeToRadian(number))
        }
        
        if abs(abs(round(result)) - abs(result)) < mathParserPrecision {
            result = round(result)
        }
        
        if result == -0.0 {
            return -result
        }
        
        return result
    }
}

struct Sinh: MathParserOperator {
    var type = MathParserOperationType.Prefix
    var priority = 5
    var startIndex = -1
    var length = 1
    
    func evaluate(numbers: [Double]) -> Double {
        let number = numbers[0]
        
        var result: Double
        
        switch mathParserAngleUnits {
        case .Radians:
            result =  sinh(number)
        case .Degrees:
            result =  sinh(degreeToRadian(number))
        }
        
        if abs(abs(round(result)) - abs(result)) < mathParserPrecision {
            result = round(result)
        }
        
        if result == -0.0 {
            return -result
        }
        
        return result
    }
}

struct Cosh: MathParserOperator {
    var type = MathParserOperationType.Prefix
    var priority = 5
    var startIndex = -1
    var length = 1
    
    func evaluate(numbers: [Double]) -> Double {
        let number = numbers[0]
        
        var result: Double
        
        switch mathParserAngleUnits {
        case .Radians:
            result = cosh(number)
        case .Degrees:
            result = cosh(degreeToRadian(number))
        }
        
        if abs(abs(round(result)) - abs(result)) < mathParserPrecision {
            result = round(result)
        }
        
        if result == -0.0 {
            return -result
        }
        
        return result
    }
}

struct Tanh: MathParserOperator {
    var type = MathParserOperationType.Prefix
    var priority = 5
    var startIndex = -1
    var length = 1
    
    func evaluate(numbers: [Double]) -> Double {
        let number = numbers[0]
        
        var result: Double
        
        switch mathParserAngleUnits {
        case .Radians:
            result = tanh(number)
        case .Degrees:
            result = tanh(degreeToRadian(number))
        }
        
        if abs(abs(round(result)) - abs(result)) < mathParserPrecision {
            result = round(result)
        }
        
        if result == -0.0 {
            return -result
        }
        
        return result
    }
}

struct Asin: MathParserOperator {
    var type = MathParserOperationType.Prefix
    var priority = 5
    var startIndex = -1
    var length = 1
    
    func evaluate(numbers: [Double]) -> Double {
        var result = asin(numbers[0])

        if mathParserAngleUnits == .Degrees {
            result = radianToDegree(result)
        }
        
        if abs(abs(round(result)) - abs(result)) < mathParserPrecision {
            result = round(result)
        }
        
        if result == -0.0 {
            return -result
        }
        
        return result
    }
}

struct Acos: MathParserOperator {
    var type = MathParserOperationType.Prefix
    var priority = 5
    var startIndex = -1
    var length = 1
    
    func evaluate(numbers: [Double]) -> Double {
        var result = acos(numbers[0])
        
        if mathParserAngleUnits == .Degrees {
            result = radianToDegree(result)
        }
        
        if abs(abs(round(result)) - abs(result)) < mathParserPrecision {
            result = round(result)
        }
        
        if result == -0.0 {
            return -result
        }
        
        return result
    }
}

struct Atan: MathParserOperator {
    var type = MathParserOperationType.Prefix
    var priority = 5
    var startIndex = -1
    var length = 1
    
    func evaluate(numbers: [Double]) -> Double {
        var result = atan(numbers[0])
        
        if mathParserAngleUnits == .Degrees {
            result = radianToDegree(result)
        }
        
        if abs(abs(round(result)) - abs(result)) < mathParserPrecision {
            result = round(result)
        }
        
        if result == -0.0 {
            return -result
        }
        
        return result
    }
}

struct Asinh: MathParserOperator {
    var type = MathParserOperationType.Prefix
    var priority = 5
    var startIndex = -1
    var length = 1
    
    func evaluate(numbers: [Double]) -> Double {
        var result = asinh(numbers[0])
        
        if mathParserAngleUnits == .Degrees {
            result = radianToDegree(result)
        }
        
        if abs(abs(round(result)) - abs(result)) < mathParserPrecision {
            result = round(result)
        }
        
        if result == -0.0 {
            return -result
        }
        
        return result
    }
}

struct Acosh: MathParserOperator {
    var type = MathParserOperationType.Prefix
    var priority = 5
    var startIndex = -1
    var length = 1
    
    func evaluate(numbers: [Double]) -> Double {
        var result = acosh(numbers[0])
        
        if mathParserAngleUnits == .Degrees {
            result = radianToDegree(result)
        }
        
        if abs(abs(round(result)) - abs(result)) < mathParserPrecision {
            result = round(result)
        }
        
        if result == -0.0 {
            return -result
        }
        
        return result    }
}

struct Atanh: MathParserOperator {
    var type = MathParserOperationType.Prefix
    var priority = 5
    var startIndex = -1
    var length = 1
    
    func evaluate(numbers: [Double]) -> Double {
        var result = atanh(numbers[0])
        
        if mathParserAngleUnits == .Degrees {
            result = radianToDegree(result)
        }
        
        if abs(abs(round(result)) - abs(result)) < mathParserPrecision {
            result = round(result)
        }
        
        if result == -0.0 {
            return -result
        }
        
        return result
    }
}


//MARK: Constants
let mathParserBracketPriority = 10
let mathParserPrecision = 1e-15
var mathParserAngleUnits = MathParserAngleUnit.Degrees
let mathParserOperators: [String: MathParserOperator] = ["+": Addition(), "-": Subtraction(), "×": Multiplication(), "÷": Division(),
                                                     "^": Power(), "√": Root(), "log": Logarithm(), "!": Factorial(), "sin": Sin(),
                                                     "cos": Cos(), "tan": Tan(), "asin": Asin(), "Acos": Acos(), "atan": Atan(),
                                                     "sinh": Sinh(), "cosh": Cosh(), "tanh": Tanh(), "asinh": Asinh(), "acosh": Acosh(), "atanh": Atanh(), "%": Percentage()]