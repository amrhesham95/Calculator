//
//  CurrencyConverterViewController.swift
//  CCCalculator
//
//  Created by Amr Hesham on 21/04/2021.
//

import UIKit

// MARK: - CurrencyConverterViewController
//
class CurrencyConverterViewController: UIViewController {
  
  //MARK: - Properties
  let viewModel = CurrencyConverterViewModel()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .blue
    // Do any additional setup after loading the view.
  }
}
