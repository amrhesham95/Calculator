//
//  NetworkManager.swift
//  CCCalculator
//
//  Created by Amr Hesham on 22/04/2021.
//

import Foundation

// MARK: - ServiceManager
//
class ServiceManager {
  
  // MARK: - Properties
  public static let shared: ServiceManager = ServiceManager()
  //https://free.currconv.com/api/v7/convert?q=USD_EGP&compact=ultra&apiKey=fdd7f10f262584b92927
}

// MARK: - ServiceManager+Network
extension ServiceManager: Network {
  func makeRequest<T: Decodable>(with url: URL, decodingType: T.Type, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) {
     URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else {
        completionHandler(nil, response, error)
        return
      }
      completionHandler(try? JSONDecoder().decode(T.self, from: data), response, nil)
     }.resume()
  }
}


