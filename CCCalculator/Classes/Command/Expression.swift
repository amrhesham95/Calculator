//
//  Expression.swift
//  CCCalculator
//
//  Created by Amr Hesham on 28/04/2021.
//

import Foundation

typealias ArithOperation = (Decimal, Decimal) -> Decimal


// MARK: - Expression
//
struct Expression {
  
  // MARK: - Properties
  
  private var number: Decimal? {
      return newNumber ?? result
  }
  
  private var newNumber: Decimal?
  private var savedOperation: ArithOperation?
  private var savedNumber: Decimal?
  private var result: Decimal?

    mutating func set(_ digit: Int) {
        newNumber = newNumber.flatMap({ Decimal(string: "\($0)\(digit)") }) ?? Decimal(digit)
    }
    
    mutating func set(_ operation: @escaping ArithOperation) {
        guard let number = number else { return }
        savedNumber = evaluateSavedOperation() ?? number
        savedOperation = operation
        newNumber = nil
        result = nil
    }
    
    mutating func evaluate() {
        result = evaluateSavedOperation()
        newNumber = nil
        savedOperation = nil
        savedNumber = nil
    }
    
    var value: Decimal? {
        return number ?? savedNumber
    }
    
    private func evaluateSavedOperation() -> Decimal? {
        guard let savedOperation = savedOperation, let number = number, let savedNumber = savedNumber else { return nil }
        return savedOperation(savedNumber, number)
    }
}
