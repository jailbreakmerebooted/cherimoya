import Foundation
import SwiftUI


public func colorToRGBString(_ color: Color) -> String {
    let uiColor = UIColor(color)
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
    uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    let redInt = Int(red * 255)
    let greenInt = Int(green * 255)
    let blueInt = Int(blue * 255)
    
    return "\(redInt),\(greenInt),\(blueInt)"
}

public func RGBStringToColor(_ rgbString: String) -> Color {
    let components = rgbString.components(separatedBy: ",").compactMap { Int($0) }
    guard components.count == 3 else {
        return .black
    }
    
    let red = Double(components[0]) / 255.0
    let green = Double(components[1]) / 255.0
    let blue = Double(components[2]) / 255.0
    
    return Color(red: red, green: green, blue: blue)
}
