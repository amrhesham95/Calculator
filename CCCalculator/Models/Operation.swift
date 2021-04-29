//
//  Operation.swift
//  CCCalculator
//
//  Created by Amr Hesham on 29/04/2021.
//

import Foundation

// MARK: - Operation
//
struct Operation {
  
  let index: Int
  let value: Double
  let type: OperationType
  var reversedType: OperationType {
    switch type {
    case .add:
      return .subtract
    case .subtract:
      return .add
    case .divide:
      return .multiply
    case .multiply:
      return .divide
    }
  }
}
