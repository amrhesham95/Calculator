//
//  OperationCommand.swift
//  CCCalculator
//
//  Created by Amr Hesham on 28/04/2021.
//

import Foundation

// MARK: - OperationCommand
//
struct OperationCommand: Command {
    init(symbol: String, _ calculator: Calculator) {
        self.symbol = symbol
        self.calculator = calculator
    }
    
    func execute() {
        calculator.enter(operationWithSymbol: symbol)
    }
    
    private let symbol: String
    private let calculator: Calculator
}
