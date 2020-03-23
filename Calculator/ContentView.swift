//
//  ContentView.swift
//  Calculator
//
//  Created by Michael Jones on 3/22/20.
//  Copyright © 2020 MakeIt-Tech. All rights reserved.
//

import SwiftUI

class HostingController: UIHostingController<ContentView> {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
enum CalculatorButton: String {
    case zero, one, two ,three, four, five, six, seven, eight, nine
    case plus, minus, multiply, divide, parenL, parenR, power
    case ac, del, decimal,changeSign
    
    var title: String {
        switch self {
            case .zero:     return "0"
            case .one:      return "1"
            case .two:      return "2"
            case .three:    return "3"
            case .four:     return "4"
            case .five:     return "5"
            case .six:      return "6"
            case .seven:    return "7"
            case .eight:    return "8"
            case .nine:     return "9"
            
            case .plus:     return "+"
            case .minus:    return "-"
            case .multiply: return "×"
            case .divide:   return "÷"
            case .parenL:   return "("
            case .parenR:   return ")"
            case .power:    return "^"
            
            case .ac:           return "AC"
            case .del:          return "Del"
            case .decimal:      return "."
            case .changeSign:   return "±"
        }
    }
    
    var backgroundColor: Color{
        switch self {
            case .ac:       return Color(red: 35 / 255, green: 35 / 255, blue: 35 / 255)
            case .del:      return Color(red: 49 / 255, green: 49 / 255, blue: 49 / 255)
            case .plus:     return Color(red: 49 / 255, green: 49 / 255, blue: 49 / 255)
            case .minus:    return Color(red: 49 / 255, green: 49 / 255, blue: 49 / 255)
            case .multiply: return Color(red: 49 / 255, green: 49 / 255, blue: 49 / 255)
            case .divide:   return Color(red: 49 / 255, green: 49 / 255, blue: 49 / 255)
            case .parenL:   return Color(red: 49 / 255, green: 49 / 255, blue: 49 / 255)
            case .parenR:   return Color(red: 49 / 255, green: 49 / 255, blue: 49 / 255)
            case .power:    return Color(red: 49 / 255, green: 49 / 255, blue: 49 / 255)
            default:        return Color(red: 59 / 255, green: 59 / 255, blue: 59 / 255)
        }
    }
    var borderRadius: CGFloat{
        switch self {
            case .ac:           return 20
            case .del:          return 20
            case .plus:         return 20
            case .minus:        return 20
            case .multiply:     return 20
            case .divide:       return 20
            case .parenL:       return 20
            case .parenR:       return 20
            case .power:        return 20
//          case .zero:         return 240
//          case .decimal:      return 40
//          case .changeSign:   return 40
            default:            return 10
        }
    }
    
    var btnWidth: CGFloat{
        switch self {
            case .parenL:   return ((UIScreen.main.bounds.width - 5 * 15) / 6)
            case .parenR:   return ((UIScreen.main.bounds.width - 5 * 15) / 6)
            case .power:    return ((UIScreen.main.bounds.width - 5 * 15) / 6)
            default:        return ((UIScreen.main.bounds.width - 5 * 15) / 4)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var env: GlobalEnviroment
    
    let buttons: [[CalculatorButton]] = [
        [.ac, .parenL,.parenR, .power, .del],
        [.seven, .eight, .nine, .divide],
        [.four, .five, .six, .multiply],
        [.one, .two, .three, .minus],
        [.zero, .decimal, .changeSign, .plus],
        
    ]
    var body: some View {
        ZStack (alignment: .bottom) {
            Color(red: 29 / 255, green: 29 / 255, blue: 29 / 255)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack{
                    Spacer()
                    //RESULT
                    Text(env.result)
                        .foregroundColor(Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                        .font(.system(size:64, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                }.padding(.bottom, -5)
                HStack{
                    Spacer()
                    //RESULT
                    Text(env.display)
                        .foregroundColor(Color(red: 180 / 255, green: 180 / 255, blue: 180 / 255))
                        .font(.system(size:54, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                    
                }.padding(.bottom, -5)
                ForEach(buttons, id: \.self) { row in
                    HStack (spacing: 7) {
                        //BUTTONS
                        ForEach(row, id: \.self) { button in
                            CalculatorButtonView(button: button)
                        }
                    }
                }.padding(.bottom, 5)
            }.padding(.bottom, -5)
        }
    }
}

struct CalculatorButtonView: View {
    
    var button: CalculatorButton
    
    @EnvironmentObject var env: GlobalEnviroment
    var body: some View{
       Button(action: {
        self.env.recieveInput(calculatorButton: self.button)
       }){
           Text(button.title)
           .font(.system(size: 32, design: .rounded))
            .frame(width: button.btnWidth, height: ((UIScreen.main.bounds.width - 5 * 15) / 4))
           .background(button.backgroundColor)
           .foregroundColor(.white)
           .cornerRadius(button.borderRadius)
         }
         
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnviroment())
    }
}

//Global App State
class GlobalEnviroment: ObservableObject{
    @Published var display = " "
    @Published var result = " "
    func recieveInput(calculatorButton: CalculatorButton) {
        if calculatorButton.title != "±"{
        if calculatorButton.title == "AC" {
            if(self.display == " "){
                self.result = " "
            }
            else{
                self.display = " "
            }
        }
        else if calculatorButton.title == "Del" {
            self.display = String(self.display.dropLast())
        }
        else{
            self.display = self.display + calculatorButton.title
        }
        
        if(self.display != ""){
            self.result = eval(self.display)
        }
    }
}

func eval(_ input: String) -> String {
        var finalResult = input
        var inputString = input.replacingOccurrences(of: "÷", with: "/")
        inputString = inputString.replacingOccurrences(of: "×", with: "*")
        while(inputString.contains("^")){
            let symbol = inputString.firstIndex(of: "^")!
            let rightOfSymbol = inputString.index(symbol, offsetBy: 1)
            print(symbol)
            var leftStr = String(inputString[..<symbol])
            var rightStr = String(inputString[rightOfSymbol...])
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
            print("R expr-", rightStr)
            let powerStr = String(leftStr + "^" + rightStr)
            inputString = inputString.replacingOccurrences(of: powerStr, with: "pow(\(leftStr),\(rightStr))")
            print(inputString)
        }
        do {
            let testExpression = Expression(inputString)
            let result = try testExpression.evaluate()
            let resultString:String = String(format: "%g", result)
            inputString = inputString.replacingOccurrences(of: "pow", with: "")
            inputString = inputString.replacingOccurrences(of: ",", with: "^")
            finalResult = inputString+" = "+resultString
            
        } catch {
            print("error")
            finalResult = input
        }
    return finalResult
    }
}


