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

    @State var scale: CGFloat = 1.0

    var body: some View {
        NavigationStack {
            ScrollView {
                CanvasView()
                    .frame(width: 1024, height: 1024)
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ (scale) in
                                self.scale = scale
                            })
                    )
                    .scaleEffect(scale)
            }
            .frame(maxWidth: .infinity)
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
