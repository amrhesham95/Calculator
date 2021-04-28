//
//  State.swift
//  CCCalculator
//
//  Created by Amr Hesham on 28/04/2021.
//

import Foundation

// MARK: - State
//
public enum State {

    /// A success, storing a `Success` value.
    case success

    /// A failure, storing a `Error` value.
    case failure(Error)

    /// A loading, indicates when loading starts
    case loading
}

extension State: Equatable {
    
    public static func == (lhs: State, rhs: State) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case (.failure, .failure):
            return true
        case (.loading, .loading):
            return true
        default:
            return false
        }
    }
}
