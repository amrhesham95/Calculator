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
  
  private let disposeBag = DisposeBag()
  
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
  
  //MARK: - Init
  override init() {
    super.init()
    bindResultToOperations()
    startListeningToNotifications()
  }
  
  func updateValueWith(_ text: String?) {
    guard let valueAsNumber = Double(text ?? "") else {
//      state.send(.failure())
      return
    }
    inputValueSubject.send(valueAsNumber)
    postTextFieldChangeNotification(value: valueAsNumber)
  }
  
  func undoOperation(at index: Int) {
    guard operations.value.count > 0,
          let type = operations.value[index]?.type,
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
    
  }
  
  func getSafeIndex() -> Int {
    for item in operations.value.reversed() where item != nil {
      return item?.index ?? .zero
    }
    return .zero
  }
  
  func getSafeIndex(with index: Int) -> Int {
    for operationIndex in index...operations.value.count - 1 where operations.value[operationIndex] != nil {
        return operationIndex
    }
    return .zero
  }
}

// MARK: - Private Operations Handlers
//
private extension CalculatorViewModel {
  
  func bindResultToOperations() {
    operations.subscribe { [weak self] in
      self?.updateresultWithOperations($0.compactMap {$0})
    }.disposed(by: disposeBag)
  }
  
  func updateresultWithOperations(_ operations: [Operation]) {
    var sum = 0.0
    resultSubject.send(0)
    sum = operations.reduce(resultSubject.value) {
      switch $1.type {
      
      case .add:
        return $1.value + $0
      case .subtract:
        return $1.value - $0
      case .divide:
        return $1.value / $0
      case .multiply:
        return $1.value * $0
      }
    }
    resultSubject.send(sum)
  }
}

// MARK: - Notifications Handlers
//
private extension CalculatorViewModel {
  
  func postTextFieldChangeNotification(value: Double) {
    
    let dataDictionary: [String: Double] = [Constants.calculatorTextFieldValue: value]
    // post a notification
    NotificationCenter.default.post(name: .CalculatorTextFieldDidChange, object: nil, userInfo: dataDictionary)
  }
  
  func startListeningToNotifications() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(didReceiveCurrencyConversionOperation), name: .DidConvertCurrencySuccessfully, object: nil)
  }
  
  @objc func didReceiveCurrencyConversionOperation(notification: NSNotification) {
    if let value = notification.userInfo?[Constants.currencyTextFieldValue] as? Double {
      let conversionOperation = Operation(index: 0, value: value, type: .add)
      operations.send([conversionOperation])
      removedOperations.removeAll()
    }
  }
}

