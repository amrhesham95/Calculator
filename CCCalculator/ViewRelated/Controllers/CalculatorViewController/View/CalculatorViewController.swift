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
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var resultLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var undoButton: UIButton!
  @IBOutlet weak var redoButton: UIButton!
  @IBOutlet weak var equalButton: UIButton!
  
  @IBOutlet var operationButtons: [UIButton]!
  
  // MARK: - Properties
  
  let viewModel = CalculatorViewModel()
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTextField()
    bindOperationsChanges()
    configureCollectionView()
    equalButtonBinding()
    undoButtonBinding()
    redoButtonBinding()
    textFieldBinding()
    resultBinding()
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
  
  func configureTextField() {
    textField.keyboardType = .asciiCapableNumberPad
  }
  func handleButtonsSelection(_ sender: UIButton) {
    operationButtons.forEach {$0.isSelected = sender == $0}
  }
  
  func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.registerCellNib(OperationCollectionViewCell.self)
    if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    collectionView.backgroundColor = .black
  }
  
  func configureCell(_ cell: OperationCollectionViewCell, with model: Operation) {
    cell.operation = model
  }
}


// MARK: - ViewModel Binding
//
private extension CalculatorViewController {
  
  func bindOperationsChanges() {
    viewModel.operations.subscribe { [weak self] _ in
      self?.collectionView.reloadData()
    }.disposed(by: disposeBag)
  }
  
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


// MARK: - CalculatorViewController+UICollectionViewDataSource
extension CalculatorViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.operationsCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeue(at: indexPath) as OperationCollectionViewCell
    let operation = viewModel.operationForRowAt(indexPath)
    configureCell(cell, with: operation)
    return cell
  }
}

// MARK: - CalculatorViewController+UICollectionViewDelegate
extension CalculatorViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    let safeIndex = viewModel.getSafeIndex(with: indexPath.row)
    viewModel.undoOperation(at: safeIndex)
  }
}

// MARK: - CalculatorViewController+UICollectionViewDelegateFlowLayout
extension CalculatorViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return Constants.CollectionViewSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return Constants.CollectionViewSpacing
  }
}
