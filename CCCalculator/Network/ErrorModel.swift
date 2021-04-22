//
//  ErrorModel.swift
//  CCCalculator
//
//  Created by Amr Hesham on 22/04/2021.
//

import Foundation

// MARK: - ErrorModel
//
class ErrorModel: Error {
  
  // MARK: - Properties
  var messageKey: String
  
  init(_ messageKey: String) {
    self.messageKey = messageKey
  }
}

// MARK: - Public Functions
extension ErrorModel {
  class func generalError() -> ErrorModel {
    return ErrorModel(ErrorKey.general.rawValue)
  }
}
