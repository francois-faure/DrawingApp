//
//  AppReducer.swift
//  DrawingApp
//
//  Created by Francois Faure on 13/11/2023.
//

import Foundation

protocol Reducer {
    func reduce(action: Action, state: ReState) async throws -> ReState
}

struct AppReducer: Reducer {
    func reduce(action: Action, state: ReState) async throws -> ReState {
        state
    }
}
