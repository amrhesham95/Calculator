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
  
  func undoOperation(at index: Int) {
    guard operations.value.count > 0,
          let type = operationType,
          let value = operations.value[index]?.value  else { return }
    
    let operation = Operation(index: index, value: value, type: type)
    var newOperations = operations.value
    newOperations[index] = nil
    
    operations.send(newOperations)
    removedOperations.append(operation)
  }
  
  func redoOperation() {
    guard removedOperations.count > 0 else { return }
    let operation = removedOperations.removeLast()
    var newOperations = operations.value
    newOperations[operation.index] = operation
    operations.send(newOperations)
  }
}

// MARK: - Public Handlers
//
extension CalculatorViewModel {
  
  func calculate() {
    
    guard let type = operationType else { return }
    var newOperations = operations.value
    newOperations.append(Operation(index: operations.value.count, value: inputValueSubject.value, type: type))
    operations.send(newOperations)
    
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
  
  func getSafeIndex() -> Int {
    for item in operations.value.reversed() where item != nil {
      return item?.index ?? .zero
    }
    return .zero
  }
  
  func getSafeIndex(with index: Int) -> Int {
    for i in index...operations.value.count - 1 {
      if operations.value[i] != nil {
        return i
      }
    }
    return .zero
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
