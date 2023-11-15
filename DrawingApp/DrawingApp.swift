//
//  DrawingAppApp.swift
//  DrawingApp
//
//  Created by Francois Faure on 09/11/2023.
//

import SwiftUI

@main
struct DrawingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            DrawingView()
                .environmentObject(
                    AppStore(
                        reducer: AppReducer(),
                        initialState: AppState()
                    )
                )
        }
    }
}
