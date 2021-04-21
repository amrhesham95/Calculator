//
//  Disposable.swift
//  CCCalculator
//
//  Created by Amr Hesham on 21/04/2021.
//

import Foundation

extension ObservationToken: Disposable {
  func dispose() {
    cancel()
  }
}

/// Represents a disposable resource.
public protocol Disposable {
  /// Dispose resource.
  func dispose()
}
