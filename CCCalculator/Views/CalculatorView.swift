//
//  CalculatorView.swift
//  CCCalculator
//
//  Created by Amr Hesham on 21/04/2021.
//

import UIKit

class CalculatorView: UIView {
  
  // MARK: - Outlets
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var textField: UITextField!
  
  // MARK: - Properties
  let calculator = Calculator()
  var commands: [Command]?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    commitInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    commitInit()
  }
  
  // MARK: - IBActions

  @IBAction func buttonTapped(_ sender: UIButton) {
    commands?[sender.tag].execute()
    guard let evaluateCommandIndex = commands?.count else { return }
    commands?[evaluateCommandIndex - 1].execute()
  }
}

// MARK: - View Configurations
//
private extension CalculatorView {
  
  func commitInit() {
    Bundle.main.loadNibNamed(CalculatorView.classNameWithoutNamespaces, owner: self, options: nil)
    contentView.addAndFixInView(self)
    
    calculator.delegate = self
//    textField.delegate = self
    textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    commands = {
  //      let digitCommands = Array(0...9).map({ DigitCommand(digit: $0, calculator) })
        let operationCommands = ["+", "-", "x", "÷"].map({ OperationCommand(symbol: $0, calculator) })
        let evaluateCommand = EvaluateCommand(calculator)
        return operationCommands + [evaluateCommand]
    }()

  }
}

// MARK: - CalculatorView+CalculatorDelegate
extension CalculatorView: CalculatorDelegate {
  func didHave(result: Decimal?) {
    print(result)
  }
}

// MARK: - CalculatorView+UITextFieldDelegate
extension CalculatorView: UITextFieldDelegate {
  @objc func textFieldDidChange(_ textField: UITextField) {
    guard let number = Int(textField.text ?? "") else {
      return
    }
    calculator.enter(digit: number)
  }
}

