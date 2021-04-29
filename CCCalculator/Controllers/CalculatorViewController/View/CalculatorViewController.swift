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
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var resultLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  
  // MARK: - Properties
  
  var viewModel = CalculatorViewModel()
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    viewModel.operations.subscribe { [weak self] _ in
      self?.tableView.reloadData()
    }.disposed(by: disposeBag)
    
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
    guard viewModel.operationsCount - 1 >= 0 else { return }
    viewModel.undoOperation(at: viewModel.getSafeIndex())
  }
  @IBAction func redoButtonTapped(_ sender: Any) {
    viewModel.redoOperation()
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


// MARK: - CalculatorViewController+UITableViewDataSource
extension CalculatorViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.operationsCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
    let operation = viewModel.operationForRowAt(indexPath)
    cell.textLabel?.text = "\(operation.value)"
    cell.detailTextLabel?.text = operation.type.rawValue
    return cell
  }
}

// MARK: - CalculatorViewController+UITableViewDelegate
extension CalculatorViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let safeIndex = viewModel.getSafeIndex(with: indexPath.row)
    viewModel.undoOperation(at: safeIndex)
  }
}
