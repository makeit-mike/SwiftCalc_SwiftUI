//
//  MathParserConstants.swift
//  Math Parser
//
//  Created by Vid Drobnic on 8/5/15.
//  Copyright (c) 2015 Vid Drobnic. All rights reserved.
//

import Foundation

protocol MathParserConstant {
    var value: Double {get}
}


struct PI: MathParserConstant {
    var value = M_PI
}

struct E: MathParserConstant {
    var value = M_E
}

let mathParserConstants: [String: MathParserConstant] = ["π": PI(), "e": E()]
