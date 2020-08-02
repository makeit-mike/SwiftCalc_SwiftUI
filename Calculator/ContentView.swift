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
///Button instantiation
enum CalculatorButton: String {
    case zero, one, two ,three, four, five, six, seven, eight, nine
    case plus, minus, multiply, divide, parenL, parenR, power
    case ac, del, decimal,changeSign
    
    var title: String {
        switch self {
        case .zero:         return "0"
        case .one:          return "1"
        case .two:          return "2"
        case .three:        return "3"
        case .four:         return "4"
        case .five:         return "5"
        case .six:          return "6"
        case .seven:        return "7"
        case .eight:        return "8"
        case .nine:         return "9"
            
        case .plus:         return "+"
        case .minus:        return "-"
        case .multiply:     return "×"
        case .divide:       return "÷"
        case .parenL:       return "("
        case .parenR:       return ")"
        case .power:        return "^"
            
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
        case .parenL:   return ((UIScreen.main.bounds.width - 5 * 15) / 6.2)
        case .parenR:   return ((UIScreen.main.bounds.width - 5 * 15) / 6.2)
        case .power:    return ((UIScreen.main.bounds.width - 5 * 15) / 6.2)
        default:        return ((UIScreen.main.bounds.width - 5 * 15) / 4)
        }
    }
}
///Content View
struct ContentView: View {
    @EnvironmentObject var env: GlobalEnviroment
    @State var viewState = CGSize.zero
    
    var body: some View {
        ZStack (alignment: .bottom) {
            Color(red: 29 / 255, green: 29 / 255, blue: 29 / 255)
                .edgesIgnoringSafeArea(.all)
            VStack { Spacer()
                ResultView()
                InputView()
                ButtonView()
            }.padding(.bottom, -5)
                .offset( y: viewState.height)
                .animation(.spring())
                .gesture(
                    DragGesture()
                        .onChanged {
                            value in self.viewState = value.translation
                    }
                    .onEnded { value in
                        self.viewState = .zero
                    }
            )
        }
    }
}
///Views
struct ResultView: View{
    @EnvironmentObject var env: GlobalEnviroment
    var body: some View {
        HStack{
            Spacer()
            //RESULT
            Text(env.result)
                .foregroundColor(Color(red: 200 / 255, green: 200 / 255, blue: 200 / 255))
                .font(.system(size:64, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.01)
        }.padding(.bottom, -5)
    }
}
struct InputView: View {
    @EnvironmentObject var env: GlobalEnviroment
    var body: some View {
        HStack{
            Spacer()
            //input
            Text(env.display)
                .foregroundColor(Color(red: 180 / 255, green: 180 / 255, blue: 180 / 255))
                .font(.system(size:54, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.01)
            
        }.padding(.bottom, -5)
    }
}

struct ButtonView: View {
    var buttons: [[CalculatorButton]] = [
        [.ac, .parenL,.parenR, .power, .del],
        [.seven, .eight, .nine, .divide],
        [.four, .five, .six, .multiply],
        [.one, .two, .three, .minus],
        [.zero, .decimal, .changeSign, .plus],
    ]
    var body: some View {
        ForEach(buttons, id: \.self) { row in
            HStack (spacing: 7) {
                //BUTTONS
                ForEach(row, id: \.self) { button in
                    CalculatorButtonView(button: button)
                }
            }
        }.padding(.bottom, 5)
    }
}

struct CalculatorButtonView: View {
    
    var button: CalculatorButton
    
    @EnvironmentObject var env: GlobalEnviroment
    
    var body: some View {
        //var text = button.title
        //if $env.display == " " {
        //  text = "tete"
        //}
        Button(action: {
            self.env.recieveInput(calculatorButton: self.button)
        }){
            Text(self.env.getTitle(title: self.button.title))
                .font(.system(size: 32, design: .rounded))
                .frame(width: button.btnWidth, height: ((UIScreen.main.bounds.width - 5 * 15) / 4))
                .background(button.backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(button.borderRadius)
        }
        
    }
}


///Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnviroment())
    }
}

///Global App State
class GlobalEnviroment: ObservableObject{
    @Published var display = " "
    @Published var result = " "
    func getTitle(title: String) -> String {
        var returnStr = title
        if title == "AC" {
            if display == " " {
                returnStr = "AC"
            } else {
                returnStr = "C"
            }
        }
        return returnStr
    }
    func recieveInput(calculatorButton: CalculatorButton) {
        if(self.display == " " && calculatorButton.title == "." ) {
            self.display = "0."
        }
        else if self.display == " " && calculatorButton.title.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return
        }
        
        switch calculatorButton.title {
        case "AC":
            if(self.display == " "){
                self.result = " "
            }
            else{
                self.display = " "
            }
        case "C":
            self.display = " "
            self.result = " "
        case "Del":
            self.display = String(self.display.dropLast())
        case "±":
            self.display = formatter.signChange(self.display)
        default:
            self.display = formatter.formatInput(current: self.display, button: calculatorButton.title)
        }
        if(self.display != ""){
            let mathematicResult: String = formatter.eval(self.display)
            print("Result \(mathematicResult)")
            
            
            //RESULT
            if mathematicResult.integer == nil {
                self.result = mathematicResult
            } else {
                let formattedResult: String = formatter.formatNumberThousands(_string: mathematicResult)
                self.result = formattedResult
            }
            
            //INPUT
            let formattedInput: String = formatter.formatNumberThousands(_string: self.display)
            self.display = formattedInput
        }
    }
}
extension StringProtocol {
    var double: Double? { Double(self) }
    var float: Float? { Float(self) }
    var integer: Int? { Int(self) }
}
