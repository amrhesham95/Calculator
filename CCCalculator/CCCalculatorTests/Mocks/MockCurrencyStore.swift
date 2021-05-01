//
//  MockCurrencyStore.swift
//  CCCalculatorTests
//
//  Created by Amr Hesham on 01/05/2021.
//

import Foundation
@testable import CCCalculator

class MockCurrencyStore: CurrencyStoreProtocol {
  var network: Network = MockNetworkManager()
  
  func getUSDExchangeRate(completion: @escaping ExchangeRateCompletion) {
    network.makeRequest(with: URL(fileURLWithPath: ""), decodingType: Currency.self) { currency, response, error in
      guard let currency = currency, error == nil else {
        completion(.failure(error ?? ErrorModel.generalError()))
        return
      }
      completion(.success(currency))
    }
  }
}
