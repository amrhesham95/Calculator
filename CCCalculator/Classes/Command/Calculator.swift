//
//  Calculator.swift
//  CCCalculator
//
//  Created by Amr Hesham on 28/04/2021.
//

import Foundation

// MARK: - Calculator
//
class Calculator {
  
  weak var delegate: CalculatorDelegate?
  
  private var expression = Expression() {
      didSet {
          delegate?.didHave(result: expression.value)
      }
  }
  
  private let operations: [String: ArithOperation] = [
      "+": { $0 + $1 }, "-": { $0 - $1 }, "x": { $0 * $1 }, "÷": { $0 / $1 }]

    func enter(digit: Int) {
        expression.set(digit)
    }
    
    func enter(operationWithSymbol symbol: String) {
        guard let operation = operations[symbol] else { return }
        expression.set(operation)
    }
    
    func evaluate() {
        expression.evaluate()
    }
    
    func allClear() {
        expression = Expression()
    }
    
}

protocol CalculatorDelegate: class {
    func didHave(result: Decimal?)
}
