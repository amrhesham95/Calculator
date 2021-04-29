//
//  Network.swift
//  CCCalculator
//
//  Created by Amr Hesham on 29/04/2021.
//

import Foundation

// MARK: - Network
//
protocol Network {
  func makeRequest<T: Decodable>(with url: URL, decodingType: T.Type, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void)
}
