//
//  DescribtionTextFieldModifier.swift
//  CoTask
//
//  Created by Ranim Alayoubi on 15/04/2021.
//

import Foundation
import SwiftUI
import CoreData

struct DescribtionTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 60)
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .background(Color.gray.opacity(0.1))
            .cornerRadius(6)
    }
}
