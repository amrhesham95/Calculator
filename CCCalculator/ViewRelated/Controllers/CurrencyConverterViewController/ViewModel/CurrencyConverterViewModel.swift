//
//  CurrencyConverterViewModel.swift
//  CCCalculator
//
//  Created by Amr Hesham on 29/04/2021.
//

import Foundation

// MARK: - CurrencyConverterViewModel
//
class CurrencyConverterViewModel: ViewModel {
  
  // MARK: - Properties
  let usdValueSubject: PublishSubject<String> = PublishSubject<String>()
  let isValidValueSubject: BehaviorSubject<Bool> = BehaviorSubject<Bool>(false)
  let converterInputValueSubject: BehaviorSubject<String> = BehaviorSubject<String>("")
  private let currencySubject: PublishSubject<Double> = PublishSubject<Double>()
  
  private let disposeBag = DisposeBag()
  private let store: CurrencyStoreProtocol
  
  // MARK: - Init
  
  init(store: CurrencyStoreProtocol = CurrencyStore()) {
    self.store = store
    super.init()
    
    startListeningToNotifications()
    bindOnCurrency()
    bindOnConverterInputValue()
  }
}

// MARK: - Public helper
//
extension CurrencyConverterViewModel {
  
  /// Get the exchange rate and convert the entered value using it 
  ///
  func convert() {
    state.send(.loading)
    store.getUSDExchangeRate { [weak self] result in
      switch result {
      case .success(let currency):
        self?.state.send(.success)
        self?.didReceiveCurrency(currency)
      case .failure(let error):
        self?.state.send(.failure(error))
      }
    }
  }
}

// MARK: - Private helper
//
private extension CurrencyConverterViewModel {
  
  /// Called when the exchange rate is received
  /// - Parameters:
  ///   - currency: returned object from the API containts the exhange rate
  func didReceiveCurrency(_ currency: Currency) {
    if let exchangeRate = currency.exchangeRate {
      currencySubject.send(exchangeRate)
    }
  }
  
  /// Bind currency change to call convertAndUpdateLabel on arrvial
  ///
  func bindOnCurrency() {
    currencySubject.subscribe { [weak self] exchangeRate in
        self?.convertAndUpdateLabel(exchangeRate: exchangeRate)
    }.disposed(by: disposeBag)
  }
  
  /// Bind text field change to validate and decide of convert button should be enabled 
  ///
  func bindOnConverterInputValue() {
    converterInputValueSubject.subscribe { [weak self] inputValue in
      guard let value = inputValue.doubleValue, value > 0 else {
        self?.isValidValueSubject.send(false)
        return
      }
      self?.isValidValueSubject.send(true)
    }.disposed(by: disposeBag)
  }
  
  /// Convert the input value to USD and update the label
  /// - Parameters:
  ///   - exchangeRate: exchange rate recieved from API
  func convertAndUpdateLabel(exchangeRate: Double) {
    guard let egpValue = converterInputValueSubject.value.doubleValue else { return }
    let usdValue = egpValue / exchangeRate
    let usdString = String(format: "%.2f", usdValue)
    
      self.usdValueSubject.send("USD: \(usdString)$")
      self.postCurrencyConversionNotification(value: egpValue)
    
  }
}

// MARK: - Notifications Handlers
//
private extension CurrencyConverterViewModel {
  /// Starts listening for Notifications
  ///
  func startListeningToNotifications() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(didReceiveCalculatorTextFieldChange), name: .CalculatorTextFieldDidChange, object: nil)
  }
  
  @objc func didReceiveCalculatorTextFieldChange(notification: NSNotification) {
    if let value = notification.userInfo?[Constants.calculatorTextFieldValue] as? Double {
      converterInputValueSubject.send("\(value)")
    }
  }
  
  /// Post notification when successful currency conversion is made
  /// - Parameters:
  ///   - value: entered value by user
  func postCurrencyConversionNotification(value: Double) {
    
    let dataDictionary: [String: Double] = [Constants.currencyTextFieldValue: value]
    // post a notification
    NotificationCenter.default.post(name: .DidConvertCurrencySuccessfully, object: nil, userInfo: dataDictionary)
  }
}
