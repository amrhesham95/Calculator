//
//  Currency.swift
//  CCCalculator
//
//  Created by Amr Hesham on 29/04/2021.
//

import Foundation

// MARK: - Currency
//
struct Currency: Decodable {
  let exchangeRate: Double?
  
  enum CodingKeys: String, CodingKey {
    case exchangeRate = "USD_EGP"
  }
}
