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
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    commitInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    commitInit()
  }
}

// MARK: - View Configurations
//
private extension CalculatorView {
  
  func commitInit() {
    Bundle.main.loadNibNamed(CalculatorView.classNameWithoutNamespaces, owner: self, options: nil)
    contentView.addAndFixInView(self)
  }
}
