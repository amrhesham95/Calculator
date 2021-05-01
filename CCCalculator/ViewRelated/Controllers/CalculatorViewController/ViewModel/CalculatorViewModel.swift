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
  
  /// Undo subject instance
  ///
  let isUndoActive = BehaviorSubject<Bool>(false)
  
  /// Redo subject instance
  ///
  let isRedoActive = BehaviorSubject<Bool>(false)
  
  /// Equal subject instance
  ///
  let isEqualActive = BehaviorSubject<Bool>(false)
    
  /// Visible operations count
  ///
  var operationsCount: Int {
    return operations.value.compactMap {$0}.count
  }
  
  /// Returns the operation assoicated with the index
  /// - Parameters:
  ///   - index: index of the selected operation
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
  
  /// Call to update the value of inputValueSubject (textfield subject)
  ///
  func updateValueWith(_ text: String?) {
    inputValueSubject.send(text ?? "")
    guard let valueAsNumber = Double(text ?? "") else {
//      state.send(.failure())
      return
    }
    postTextFieldChangeNotification(value: valueAsNumber)
  }
  
  /// Call to undo an operation
  ///
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
  
  /// Call to redo an operation
  ///
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
  
  /// Bind undo button subject to the operations list
  ///
  func bindIsUndoActive() {
    operations.subscribe { [weak self] operations in
      self?.isUndoActive.send(!operations.compactMap{$0}.isEmpty)
    }.disposed(by: disposeBag)
  }
  
  /// Bind redo button subject to the operations list
  ///
  func bindIsRedoActive() {
    removedOperations.subscribe { [weak self] removedOperations in
      self?.isRedoActive.send(!removedOperations.isEmpty)
    }.disposed(by: disposeBag)
  }
  
  /// Bind equal button subject to the operations list
  ///
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
  
  /// Do the calculations based on `OperationType` and `Value`
  ///
  func calculate() {
    
    guard let type = operationType else { return }
    var newOperations = operations.value
    newOperations.append(Operation(index: operations.value.count, value: inputValueSubject.value.doubleValue ?? .zero, type: type))
    operations.send(newOperations)
  }
  
  /// Get the last index of a list that has a value and not nil
  ///
  func getSafeIndex() -> Int {
    for item in operations.value.reversed() where item != nil {
      return item?.index ?? .zero
    }
    return .zero
  }
  
  /// Get the next index after `index` of a list that has a value and not nil
  ///
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
  
  /// Bind updating result on every change of the operations list
  ///
  func bindResultToOperations() {
    operations.subscribe { [weak self] in
      self?.updateresultWithOperations($0.compactMap {$0})
    }.disposed(by: disposeBag)
  }
  
  /// Calculate the result based on the operations that happened
  /// - Parameters:
  ///   - operations: operations made by the user
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
  
  /// Post notification when calculator text field value change
  /// - Parameters:
  ///   - value: entered value by user
  func postTextFieldChangeNotification(value: Double) {
    
    let dataDictionary: [String: Double] = [Constants.calculatorTextFieldValue: value]
    // post a notification
    NotificationCenter.default.post(name: .CalculatorTextFieldDidChange, object: nil, userInfo: dataDictionary)
  }
  
  /// Listen for currency conversion notification
  ///
  func startListeningToNotifications() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(didReceiveCurrencyConversionOperation), name: .DidConvertCurrencySuccessfully, object: nil)
  }
  
  /// Updates the operations list with the with conversion as if it was an operation and clear all the previous operations and removed operations on notification received
  /// - Parameters:
  ///   - notification: notification send by CurrencyConversion screen when a successful conversion is made
  @objc func didReceiveCurrencyConversionOperation(notification: NSNotification) {
    if let value = notification.userInfo?[Constants.currencyTextFieldValue] as? Double {
      let conversionOperation = Operation(index: 0, value: value, type: .add)
      operations.send([conversionOperation])
      removedOperations.send([])
    }
  }
}


