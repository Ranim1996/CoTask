//
//  ColorExtension.swift
//  CoTask
//
//  Created by Rawan Abou Dehn on 15/04/2021.
//

import Foundation
import SwiftUI
import CoreData
import AVFoundation

// MARK: - COLOR EXTENSION
prefix operator ⋮
prefix func ⋮(hex:UInt32) -> Color {
    return Color(hex)
}

extension Color {
    init(_ hex: UInt32, opacity:Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

let hexColor:(UInt32) -> (Color) = {
    return Color($0)
}



// MARK: - UICOLOR EXTENSION
extension UIColor {
    var suColor: Color { Color(self) }

    public convenience init?(hex: String, red: Int, green: Int, blue: Int) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat(red)  / 255
                    g = CGFloat(green) / 255
                    b = CGFloat(blue) / 255
                    a = CGFloat(hexNumber & 0x000000) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
