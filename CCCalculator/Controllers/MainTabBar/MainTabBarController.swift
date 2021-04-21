//
//  MainTabBarController.swift
//  CCCalculator
//
//  Created by Amr Hesham on 21/04/2021.
//

import Foundation
import UIKit

// MARK: - MainTabBarController
//
class MainTabBarController: UITabBarController {
  
  // MARK: - Properties
  
  private let calculatorViewController: CalculatorViewController = {
    return CalculatorViewController()
  }()
  
  private let currencyConverterViewController: CurrencyConverterViewController = {
    return CurrencyConverterViewController()
  }()


  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTabViewControllers()
    configureTabBarItems()
  }
}

// MARK: - Helpers
//
private extension MainTabBarController {
  
  /// Configure tab view controllers,
  /// used at view initialization to setup the visible view controllers.
  ///
  func configureTabViewControllers() {
    viewControllers = {
      var controllers = viewControllers ?? []
      
      let calculatorTabIndex = AppTab.calculator.visibleIndex()
      controllers.insert(UINavigationController(rootViewController: calculatorViewController), at: calculatorTabIndex)
      
      let currencyConverterTabIndex = AppTab.currencyConverter.visibleIndex()
      controllers.insert(UINavigationController(rootViewController: currencyConverterViewController), at: currencyConverterTabIndex)

      
      return controllers
    }()
  }
  
  /// Create TabBar items for visible items
  ///
  func configureTabBarItems() {
   
    let calculatorTab = UITabBarItem(title: "Calculator", image: nil, selectedImage: nil)
    calculatorViewController.navigationController?.tabBarItem = calculatorTab
    
    let currencyConverterTab = UITabBarItem(title: "Converter", image: nil, selectedImage: nil)
    currencyConverterViewController.navigationController?.tabBarItem = currencyConverterTab
  }
}
