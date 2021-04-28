//
//  DigitCommand.swift
//  CCCalculator
//
//  Created by Amr Hesham on 28/04/2021.
//

import Foundation
// MARK: - DigitCommand
//
struct DigitCommand: Command {
    init(digit: Int, _ calculator: Calculator) {
        self.digit = digit
        self.calculator = calculator
    }
    
    func execute() {
        calculator.enter(digit: digit)
    }
    
    private let digit: Int
    private let calculator: Calculator
}
