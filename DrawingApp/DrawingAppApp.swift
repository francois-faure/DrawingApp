//
//  DrawingAppApp.swift
//  DrawingApp
//
//  Created by Francois Faure on 09/11/2023.
//

import SwiftUI

@main
struct DrawingAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
