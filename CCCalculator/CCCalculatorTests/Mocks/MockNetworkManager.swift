//
//  MockNetworkManager.swift
//  CCCalculatorTests
//
//  Created by Amr Hesham on 01/05/2021.
//

import Foundation
@testable import CCCalculator

class MockNetworkManager: Network {
  func makeRequest<T>(with url: URL, decodingType: T.Type, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) where T : Decodable {
    let mockedDictionary = ["USD_EGP": 15.8]
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: mockedDictionary, options: .prettyPrinted)
        let decodedCurrency = try JSONDecoder().decode(T.self, from: jsonData)
        completionHandler(decodedCurrency, nil, nil)
    } catch {
      completionHandler(nil, nil, ErrorModel.generalError())
    }
  }
}

