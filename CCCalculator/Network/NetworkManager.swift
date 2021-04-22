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
  
  public var baseURL: String = "https://free.currconv.com/api/v7/"
}

// MARK: - Public Functions
extension ServiceManager {
  
  func sendRequest<T: Codable>(request: RequestModel, completion: @escaping(Result<T, Error>) -> Void) {
    
    URLSession.shared.dataTask(with: request.urlRequest()) { data, response, error in
      guard let data = data, var responseModel = try? JSONDecoder().decode(ResponseModel<T>.self, from: data) else {
          let error: ErrorModel = ErrorModel(ErrorKey.parsing.rawValue)
          print(error)
          
          completion(Result.failure(error))
          return
        }
        
        responseModel.request = request
        
        if request.isLoggingEnabled.1 {
          print(responseModel)
        }
        
      if responseModel.isSuccess ?? false, let data = responseModel.data {
          completion(Result.success(data))
        } else {
          completion(Result.failure(ErrorModel.generalError()))
        }
        
      }.resume()
    }
}
