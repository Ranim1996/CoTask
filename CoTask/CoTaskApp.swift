//
//  CoTaskApp.swift
//  CoTask
//
//  Created by Ranim Alayoubi on 10/04/2021.
//

import SwiftUI

@main
struct CoTaskApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
