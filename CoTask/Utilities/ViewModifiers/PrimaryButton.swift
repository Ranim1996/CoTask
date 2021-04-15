//
//  PrimaryButton.swift
//  CoTask
//
//  Created by Rawan Abou Dehn on 15/04/2021.
//

import Foundation
import SwiftUI
import CoreData

// Custome modifier to style primary buttons
struct PrimaryButton: ViewModifier {
    let maxWidth: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(minWidth: 0, maxWidth: self.maxWidth)
            .background(Color(UIColor(named: "Primary")!))
//            .background(Color(0x723452))
            .cornerRadius(9)
            .foregroundColor(Color(UIColor(named: "Accent")!))
    }
}
