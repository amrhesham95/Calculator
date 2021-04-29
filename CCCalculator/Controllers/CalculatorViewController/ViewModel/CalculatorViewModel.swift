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
  
  var operations: BehaviorSubject<[Operation?]> = BehaviorSubject<[Operation?]>([])
  
  var operationsCount: Int {
    return operations.value.compactMap {$0}.count
  }
  
  func operationForRowAt(_ index: IndexPath) -> Operation {
    return operations.value.compactMap {$0}[index.row]
  }
  
  // maybe replaced with stack
  var removedOperations = [Operation]()
  
  /// Operation type that is currently chosen (+, -, *, /)
  ///
  var operationType: OperationType?
  
  var reversedType: OperationType? {
    switch operationType {
    case .add:
      return .subtract
    case .subtract:
      return .add
    case .divide:
      return .multiply
    case .multiply:
      return .divide
    case .none:
      return nil
    }
  }

  
  /// Result subject instance
  ///
  var resultSubject = BehaviorSubject<Double>(0)
  
  /// Result observable instance
  ///
  var resultObservable: Observable<Double> {
    return resultSubject
  }
  
  /// Result subject instance
  ///
  var inputValueSubject = BehaviorSubject<Double>(0)
  
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
  
  func addNewOperation() {
    let operation = removedOperations.count > 0 ? removedOperations.removeLast() : Operation(index: 0, value: inputValueSubject.value, type: operationType!)
    var newOperations = operations.value
    newOperations.append(operation)
    operations.send(newOperations)
  }
  
  func addNewOperationFromEqualButton() {
    let operation = Operation(index: operations.value.count, value: inputValueSubject.value, type: operationType!)
    var newOperations = operations.value
    newOperations.append(operation)
    operations.send(newOperations)
  }
  
  func addDeletedOperationBack(_ index: Int) {
    guard removedOperations.count > 0 else { return }
    let operation = removedOperations.removeLast()
    var newOperations = operations.value
    newOperations.insert(operation, at: operation.index)
    operations.send(newOperations)
  }

  func removeOperationAt(_ index: Int) {
    var newOperations = operations.value
    let removedOperation = newOperations[index]
    newOperations[index] = nil
    operations.send(newOperations)
    guard let operation = removedOperation else { return }
   removedOperations.append(operation)
  }

  func removeNewOperation() {
    var newOperations = operations.value
    let removedOperation = newOperations.removeLast()
    operations.send(newOperations)
    guard let operation = removedOperation else { return }
   removedOperations.append(operation)
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
