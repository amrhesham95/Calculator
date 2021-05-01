//
//  CurrencyConverterViewController.swift
//  CCCalculator
//
//  Created by Amr Hesham on 21/04/2021.
//

import UIKit

// MARK: - CurrencyConverterViewController
//
class CurrencyConverterViewController: ViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var usdLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var convertButton: UIButton!
  
  
  
  //MARK: - Properties
  
  private let viewModel = CurrencyConverterViewModel()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setDoneOnKeyboardTo(textField)
    configureTextField()
    bindOnTextFieldObserevable()
    textFieldBinding()
    bindUSDValue()
    bindIsValidValue()
    bindErrorState(to: viewModel)
    bindLoadingState(to: viewModel)
  }
  
  // MARK: - IBActions
  
  /// Convert button action
  ///
  @IBAction func convertButtonTapped(_ sender: Any) {
    viewModel.convert()
  }
}

// MARK: - View Configurations
//
extension CurrencyConverterViewController {
  /// Text field configurations (keypadType,)
  ///
  func configureTextField() {
    textField.keyboardType = .asciiCapableNumberPad
  }
}

// MARK: - ViewModel Binding
//
private extension CurrencyConverterViewController {
  
  func bindUSDValue() {
    viewModel.usdValueSubject.subscribe { [weak self] usdValue in
      DispatchQueue.main.async {
        self?.usdLabel.text = usdValue
      }
    }.disposed(by: disposeBag)
  }
  
  func bindIsValidValue() {
    viewModel.isValidValueSubject.subscribe { [weak self] isValid in
      self?.convertButton.isEnabled = isValid
    }.disposed(by: disposeBag)
  }
  
  func bindOnTextFieldObserevable() {
    viewModel.converterInputValueSubject.subscribe { [weak self] inputValue in
      self?.textField.text = "\(inputValue)"
    }.disposed(by: disposeBag)
  }

  func textFieldBinding() {
    textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    viewModel.converterInputValueSubject.send(textField.text ?? "")
  }
}
