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
  
  // MARK: - Outlets
  
  @IBOutlet weak var resultLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  
  // MARK: - Properties
  
  let viewModel = CalculatorViewModel()
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textFieldBinding()
    resultBinding()
  }
}

// MARK: - IBActions
//
private extension CalculatorViewController {
  
  @IBAction func addButtonTapped(_ sender: Any) {
    viewModel.operationType = .add
  }
  @IBAction func subtractButtonTapped(_ sender: Any) {
    viewModel.operationType = .subtract
  }
  @IBAction func divideButtonTapped(_ sender: Any) {
    viewModel.operationType = .divide
  }
  @IBAction func multiplyButtonTapped(_ sender: Any) {
    viewModel.operationType = .multiply
  }
  @IBAction func equalButtonTapped(_ sender: Any) {
    viewModel.calculate()
  }
  @IBAction func undoButtonTapped(_ sender: Any) {
    undoManager?.undo()
  }
  @IBAction func redoButtonTapped(_ sender: Any) {
    undoManager?.redo()
  }
}


// MARK: - ViewModel Binding
//
private extension CalculatorViewController {
  
  func resultBinding() {
    viewModel.resultObservable.subscribe { [weak self] value in
      self?.resultLabel.text = String("\(value)")
    }.disposed(by: disposeBag)
  }
  
  func textFieldBinding() {
    textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    viewModel.updateValueWith(textField.text)
  }
}
