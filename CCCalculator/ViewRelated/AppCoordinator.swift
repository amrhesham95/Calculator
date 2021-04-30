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
  
  let viewModel = CalculatorViewModel()
  let ccViewModel = CurrencyConverterViewModel()
  private lazy var calculatorViewController: CalculatorViewController = {
    return CalculatorViewController(viewModel: viewModel)
  }()
  
  private lazy var currencyConverterViewController: CurrencyConverterViewController = {
    return CurrencyConverterViewController(viewModel: ccViewModel)
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

