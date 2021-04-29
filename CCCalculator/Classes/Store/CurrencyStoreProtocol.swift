//
//  Store.swift
//  CCCalculator
//
//  Created by Amr Hesham on 29/04/2021.
//

import Foundation

// MARK: - Typealias
typealias ExchangeRateCompletion = (Result<Currency, Error>) -> Void

// MARK: - Store
//
protocol CurrencyStoreProtocol {
  var network: Network { get }
  func getUSDExchangeRate(completion: @escaping ExchangeRateCompletion)
}
