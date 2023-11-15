//
//  Store.swift
//  DrawingApp
//
//  Created by Francois Faure on 13/11/2023.
//

import Foundation

protocol Action {}

actor AppStore: ObservableObject {
    @MainActor @Published private(set) var state: ReState
    private let reducer: Reducer

    @MainActor
    init(reducer: Reducer, initialState: ReState) {
        self.reducer = reducer
        self.state = initialState
    }

    func dispatch(action: Action) async throws {
        let newState = try await reducer.reduce(action: action, state: state)
        Task { @MainActor in
            state = newState
        }
    }
}
