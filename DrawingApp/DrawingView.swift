//
//  ContentView.swift
//  DrawingApp
//
//  Created by Francois Faure on 09/11/2023.
//

import SwiftUI
import CoreData

struct DrawingView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        NavigationStack {
            Group {
                CanvasView()
                    .panScaleRotate()
                    .frame(width: 512, height: 512)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray)
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button("Press Me") {
                        print("Pressed")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
            .environmentObject(
                Store(
                    reducer: AppReducer(),
                    initialState: AppState()
                )
        )
    }
}
