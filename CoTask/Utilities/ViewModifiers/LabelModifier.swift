//
//  LabelModifier.swift
//  CoTask
//
//  Created by Ranim Alayoubi on 15/04/2021.
//

import Foundation
import SwiftUI
import CoreData

// Custome modifier to style Labels in Task Details Page
struct LabelModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
    }
}
