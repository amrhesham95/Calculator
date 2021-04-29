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
  
  private let currencySubject: PublishSubject<Double> = PublishSubject<Double>()
  private let store: CurrencyStoreProtocol
  
  // MARK: - Init
  
  init(store: CurrencyStoreProtocol = CurrencyStore()) {
    self.store = store
  }
}

// MARK: - Public helper
//
extension CurrencyConverterViewModel {
  func getExchangeRate() {
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
}

