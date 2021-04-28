//
//  CalculatorViewModel.swift
//  CCCalculator
//
//  Created by Amr Hesham on 28/04/2021.
//

import Foundation

// MARK: - CalculatorViewModel
//
class CalculatorViewModel: ViewModel {
  
  // MARK: - Properties
  
  /// Operation type that is currently chosen (+, -, *, /)
  ///
  var operationType: OperationType?
  
  /// Result subject instance
  ///
  private var resultSubject = BehaviorSubject<Double>(0)
  
  /// Result observable instance
  ///
  var resultObservable: Observable<Double> {
    return resultSubject
  }
  
  /// Result subject instance
  ///
  private var inputValueSubject = BehaviorSubject<Double>(0)
  
  /// Result observable instance
  ///
  var inputValueObservable: Observable<Double> {
    return inputValueSubject
  }
  
  func updateValueWith(_ text: String?) {
    guard let valueAsNumber = Double(text ?? "") else {
//      state.send(.failure())
      return
    }
    inputValueSubject.send(valueAsNumber)
  }
}

// MARK: - Public Handlers
//
extension CalculatorViewModel {
  func calculate() {
    guard let type = operationType else { return }
    switch type {
    case .add:
      add()
    case .subtract:
      subtract()
    case .divide:
      divide()
    case .multiply:
      multiply()
    }
  }
}

// MARK: - Private Operations Handlers
//
private extension CalculatorViewModel {
  func add() {
    resultSubject.send(inputValueSubject.value + resultSubject.value)
  }
  func subtract() {
    resultSubject.send( resultSubject.value - inputValueSubject.value)
  }
  func divide() {
    resultSubject.send(resultSubject.value / inputValueSubject.value )
  }
  func multiply() {
    resultSubject.send(inputValueSubject.value * resultSubject.value)
  }
}
