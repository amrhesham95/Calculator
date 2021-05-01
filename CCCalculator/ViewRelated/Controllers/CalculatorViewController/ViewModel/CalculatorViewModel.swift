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
  var removedOperations: BehaviorSubject<[Operation]> = BehaviorSubject<[Operation]>([])
  let isUndoActive = BehaviorSubject<Bool>(false)
  let isRedoActive = BehaviorSubject<Bool>(false)
  let isEqualActive = BehaviorSubject<Bool>(false)
    
  var operationsCount: Int {
    return operations.value.compactMap {$0}.count
  }
  
  func operationForRowAt(_ index: IndexPath) -> Operation {
    return operations.value.compactMap {$0}[index.row]
  }
  
  /// Operation type that is currently chosen (+, -, *, /)
  ///
  var operationType: OperationType? {
    didSet {
      let isEqualActive = !inputValueSubject.value.isEmpty && operationType != nil ? true : false
      self.isEqualActive.send(isEqualActive)
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
  var inputValueSubject = BehaviorSubject<String>("")
  
  /// Result observable instance
  ///
  var inputValueObservable: Observable<String> {
    return inputValueSubject
  }
  
  //MARK: - Init
  override init() {
    super.init()
    
    bindIsEqualActive()
    bindIsUndoActive()
    bindIsRedoActive()
    bindResultToOperations()
    startListeningToNotifications()
  }
  
  func updateValueWith(_ text: String?) {
    inputValueSubject.send(text ?? "")
    guard let valueAsNumber = Double(text ?? "") else {
//      state.send(.failure())
      return
    }
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
    
    var newRemovedOperations = removedOperations.value
    newRemovedOperations.append(operation)
    removedOperations.send(newRemovedOperations)
  }
  
  func redoOperation() {
    guard removedOperations.value.count > 0 else { return }
    var newRemovedOperations = removedOperations.value
    let operation = newRemovedOperations.removeLast()
    removedOperations.send(newRemovedOperations)
    var newOperations = operations.value
    newOperations[operation.index] = operation
    operations.send(newOperations)
  }
}

// MARK: - Binding
//
private extension CalculatorViewModel {
  func bindIsUndoActive() {
    operations.subscribe { [weak self] operations in
      self?.isUndoActive.send(!operations.compactMap{$0}.isEmpty)
    }.disposed(by: disposeBag)
  }
  
  func bindIsRedoActive() {
    removedOperations.subscribe { [weak self] removedOperations in
      self?.isRedoActive.send(!removedOperations.isEmpty)
    }.disposed(by: disposeBag)
  }
  
  func bindIsEqualActive() {
    inputValueObservable.subscribe { [weak self] inputValue in
      let isEqualActive = !inputValue.isEmpty && self?.operationType != nil ? true : false
      self?.isEqualActive.send(isEqualActive)
    }.disposed(by: disposeBag)
  }

}

// MARK: - Public Handlers
//
extension CalculatorViewModel {
  
  func calculate() {
    
    guard let type = operationType else { return }
    var newOperations = operations.value
    newOperations.append(Operation(index: operations.value.count, value: inputValueSubject.value.doubleValue ?? .zero, type: type))
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
        return $0 + $1.value
      case .subtract:
        return $0 - $1.value
      case .divide:
        return $0 / $1.value
      case .multiply:
        return $0 * $1.value
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
      removedOperations.send([])
    }
  }
}


