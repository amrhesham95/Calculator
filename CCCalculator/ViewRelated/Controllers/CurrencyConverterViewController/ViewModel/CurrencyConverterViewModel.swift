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
  let converterInputValueSubject: BehaviorSubject<String> = BehaviorSubject<String>("")
  private let currencySubject: PublishSubject<Double> = PublishSubject<Double>()
  private let disposeBag = DisposeBag()
  private let store: CurrencyStoreProtocol
  
  // MARK: - Init
  
  init(store: CurrencyStoreProtocol = CurrencyStore()) {
    self.store = store
    super.init()
    
    bindOnCurrency()
  }
}

// MARK: - Public helper
//
extension CurrencyConverterViewModel {
  func convert() {
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
  
  func didReceiveCurrency(_ currency: Currency) {
    if let exchangeRate = currency.exchangeRate {
      currencySubject.send(exchangeRate)
    }
  }
  
  func bindOnCurrency() {
    currencySubject.subscribe { [weak self] exchangeRate in
      self?.convertAndUpdateLabel(exchangeRate: exchangeRate)
    }.disposed(by: disposeBag)
  }
  
  func convertAndUpdateLabel(exchangeRate: Double) {
    guard let egpValue = converterInputValueSubject.value.doubleValue else { return }
    let usdValue = egpValue / exchangeRate
    let usdString = String(format: "%.2f", usdValue)
    DispatchQueue.main.async { [weak self] in
      self?.usdValueSubject.send("USD: \(usdString)$")
    }
  }
}

