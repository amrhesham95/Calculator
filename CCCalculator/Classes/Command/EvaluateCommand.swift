//
//  EvaluateCommand.swift
//  CCCalculator
//
//  Created by Amr Hesham on 28/04/2021.
//

import Foundation

// MARK: -  EvaluateCommand
//
struct EvaluateCommand: Command {
    init(_ calculator: Calculator) {
        self.calculator = calculator
    }
    
    func execute() {
        calculator.evaluate()
    }
    
    private let calculator: Calculator
}
