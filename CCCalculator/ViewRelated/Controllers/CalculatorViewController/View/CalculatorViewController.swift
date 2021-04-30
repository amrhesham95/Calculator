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
  @IBOutlet weak var undoButton: UIButton!
  @IBOutlet weak var redoButton: UIButton!
  @IBOutlet weak var equalButton: UIButton!
  
  @IBOutlet var operationButtons: [UIButton]!
  
  // MARK: - Properties
  
  let viewModel: CalculatorViewModel
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    viewModel.operations.subscribe { [weak self] _ in
      self?.tableView.reloadData()
    }.disposed(by: disposeBag)
    
    equalButtonBinding()
    undoButtonBinding()
    redoButtonBinding()
    textFieldBinding()
    resultBinding()
  }
  
  // MARK: - Init
  
  init(viewModel: CalculatorViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - IBActions
//
private extension CalculatorViewController {
  
  @IBAction func addButtonTapped(_ sender: UIButton) {
    viewModel.operationType = .add
    handleButtonsSelection(sender)
  }
  @IBAction func subtractButtonTapped(_ sender: UIButton) {
    viewModel.operationType = .subtract
    handleButtonsSelection(sender)
  }
  @IBAction func divideButtonTapped(_ sender: UIButton) {
    viewModel.operationType = .divide
    handleButtonsSelection(sender)
  }
  @IBAction func multiplyButtonTapped(_ sender: UIButton) {
    viewModel.operationType = .multiply
    handleButtonsSelection(sender)
  }
  @IBAction func equalButtonTapped(_ sender: UIButton) {
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

// MARK: - View Configurations
private extension CalculatorViewController {
  func handleButtonsSelection(_ sender: UIButton) {
    operationButtons.forEach {$0.isSelected = sender == $0}
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
  
  func undoButtonBinding() {
    viewModel.isUndoActive.subscribe { [weak self] isActive in
      self?.undoButton.isEnabled = isActive
    }.disposed(by: disposeBag)
  }
  
  func redoButtonBinding() {
    viewModel.isRedoActive.subscribe { [weak self] isActive in
      self?.redoButton.isEnabled = isActive
    }.disposed(by: disposeBag)
  }
  
  func equalButtonBinding() {
    viewModel.isEqualActive.subscribe { [weak self] isActive in
      self?.equalButton.isEnabled = isActive
    }.disposed(by: disposeBag)
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
