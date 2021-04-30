//
//  NotificationNames+Helpers.swift
//  CCCalculator
//
//  Created by Amr Hesham on 30/04/2021.
//

import Foundation

// MARK: - NotificationNames+Helpers
//
public extension NSNotification.Name {
  
  /// Posted whenever a calculator text field change happens.
  ///
  static let CalculatorTextFieldDidChange = NSNotification.Name(rawValue: Constants.CalculatorTextFieldDidChange)
  
  /// Posted whenever a currency conversion was made successfully.
  ///
  static let DidConvertCurrencySuccessfully = Notification.Name(Constants.DidConvertCurrencySuccessfully)
}
