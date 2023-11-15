//
//  ContentView.swift
//  DrawingApp
//
//  Created by Francois Faure on 09/11/2023.
//

import SwiftUI
import CoreData

struct DrawingView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        NavigationStack {
            Group {
                CanvasView()
                    .panScaleRotate()
                    .frame(width: 512, height: 512)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray)
            .toolbar(id: "item.toolbar") {
                ToolbarItem(id: "item.pencil", placement: .primaryAction) {
                    Button(action: {}) {
                        Image(systemName: "pencil")
                    }
                }
                ToolbarItem(id: "item.eraser", placement: .secondaryAction) {
                    Button(action: {}) {
                        Image(systemName: "eraser")
                    }
                }
            }
            .toolbarBackground(.visible, for: .tabBar, .navigationBar)
            .toolbarBackground(.white, for: .tabBar, .navigationBar)
            .toolbarColorScheme(ColorScheme.light, for: .tabBar)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
            .environmentObject(
                AppStore(
                    reducer: AppReducer(),
                    initialState: AppState()
                )
        )
    }
}
