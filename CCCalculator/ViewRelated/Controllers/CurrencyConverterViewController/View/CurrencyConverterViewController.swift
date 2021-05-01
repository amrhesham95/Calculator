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
  
  private let viewModel: CurrencyConverterViewModel
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindOnTextFieldObserevable()
    textFieldBinding()
    bindUSDValue()
    bindIsValidValue()
    bindErrorState(to: viewModel)
    bindLoadingState(to: viewModel)
  }
  
  // MARK: - Init
  
  init(viewModel: CurrencyConverterViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @IBAction func convertButtonTapped(_ sender: Any) {
    viewModel.convert()
  }
}

// MARK: - ViewModel Binding
//
extension CurrencyConverterViewController {
  func bindUSDValue() {
    viewModel.usdValueSubject.subscribe { [weak self] usdValue in
      self?.usdLabel.text = usdValue
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
