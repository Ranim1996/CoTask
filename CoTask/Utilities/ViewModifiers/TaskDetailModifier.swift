//
//  TaskDetailModifier.swift
//  CoTask
//
//  Created by Ranim Alayoubi on 15/04/2021.
//

import Foundation
import SwiftUI
import CoreData

// Custome modifier to style Text view in Task Details Page
struct TaskdetailModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.secondary)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
    }
}
