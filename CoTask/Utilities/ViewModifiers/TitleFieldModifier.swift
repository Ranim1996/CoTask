//
//  TitleFieldModifier.swift
//  CoTask
//
//  Created by Ranim Alayoubi on 15/04/2021.
//

import Foundation
import SwiftUI
import CoreData

// Custome modifier to style describtionfields in Add task Page
struct TitleFieldModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .background(Color.gray.opacity(0.1))
            .cornerRadius(6)
    }
}
