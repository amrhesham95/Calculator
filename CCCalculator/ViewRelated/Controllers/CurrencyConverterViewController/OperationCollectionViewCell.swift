//
//  OperationCollectionViewCell.swift
//  CCCalculator
//
//  Created by Amr Hesham on 30/04/2021.
//

import UIKit

// MARK: - OperationCollectionViewCell
//
class OperationCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Outlet
  
  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var operationLabel: UILabel!
  
  // MARK: - Properties
  
  var operation: Operation? {
    didSet {
      updateCell()
    }
  }
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    configureView()
    
  }
}

// MARK: - View Configuration
//
extension OperationCollectionViewCell {
  func updateCell() {
    guard let operation = operation else { return }
    operationLabel.text = operation.description
  }
  
  func configureView() {
    mainView.layer.borderWidth = 5
    mainView.layer.borderColor = UIColor.white.cgColor
    operationLabel.textColor = .white
  }
}
