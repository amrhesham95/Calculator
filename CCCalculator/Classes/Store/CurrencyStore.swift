//
//  CurrencyStore.swift
//  CCCalculator
//
//  Created by Amr Hesham on 29/04/2021.
//

import Foundation

// MARK: - CurrencyStore
//
class CurrencyStore: CurrencyStoreProtocol {
  
  // MARK: - Properties
  
  var network: Network
  
  // MARK: - Init
  init(network: Network = ServiceManager.shared) {
    self.network = network
  }
}

// MARK: - Network Handlers
extension CurrencyStore {
  func getUSDExchangeRate(completion: @escaping ExchangeRateCompletion) {
    // TODO: Move to constants file
    let urlToBeMovedToConstant = "https://free.currconv.com/api/v7/convert?q=USD_EGP&compact=ultra&apiKey=fdd7f10f262584b92927"
    guard let url = URL(string: urlToBeMovedToConstant) else { return }
    network.makeRequest(with: url, decodingType: Currency.self) { currency, response, error in
      guard let currency = currency, error == nil else {
        completion(.failure(ErrorModel.generalError()))
        return
      }
      
      completion(.success(currency))
    }
  }
}
