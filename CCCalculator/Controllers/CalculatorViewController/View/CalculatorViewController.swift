//
//  CalculatorViewController.swift
//  CCCalculator
//
//  Created by Amr Hesham on 21/04/2021.
//

import UIKit

// MARK: - CalculatorViewController
//
class CalculatorViewController: UIViewController {
  
  // MARK: - Properties
  
  let viewModel = CalculatorViewModel()
  let calculator = Calculator()
  var commands: [Command]?
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
   
    view.backgroundColor = .red
    
    commands = {
  //      let digitCommands = Array(0...9).map({ DigitCommand(digit: $0, calculator) })
        let operationCommands = ["+", "-", "x", "÷"].map({ OperationCommand(symbol: $0, calculator) })
  //      let evaluateCommand = EvaluateCommand(calculator)
        return operationCommands
    }()

    // Do any additional setup after loading the view.
  }
  
  // MARK: - IBActions
  
  @IBAction func buttonTapped(_ sender: UIButton) {
    commands?[sender.tag].execute()
  }

}
