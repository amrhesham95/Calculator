//
//  AppCoordinator.swift
//  CCCalculator
//
//  Created by Amr Hesham on 30/04/2021.
//

import UIKit

// MARK: - AppCoordinator
//
class AppCoordinator {
    
  private var isLoggedIn: Bool?
  
  // MARK: - Properties
    
  private let calculatorViewController: CalculatorViewController = {
    return CalculatorViewController()
  }()
  
  private let currencyConverterViewController: CurrencyConverterViewController = {
    return CurrencyConverterViewController()
  }()
  
  /// Tab Bar Controller
  ///
  lazy var tabBarController: MainTabBarController? = {
      MainTabBarController(calculatorViewController: calculatorViewController, currencyConverterViewController: currencyConverterViewController)
  }()
}

// MARK: - Coordination Helpers
//
extension AppCoordinator {
  
}

