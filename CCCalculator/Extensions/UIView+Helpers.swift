//
//  UIView+Helpers.swift
//  CCCalculator
//
//  Created by Amr Hesham on 22/04/2021.
//

import UIKit


// MARK: - UIView + Helpers
//
extension UIView {
  
  /// Add and fix `UIView` on `ContainerView`
  ///
  func addAndFixInView(_ container: UIView, space: CGFloat = .zero) {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.frame = container.frame
    container.addSubview(self)
    
    let constraints = [
      NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: space),
      NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: -space),
      NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: space),
      NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: -space)
    ]
    
    constraints.forEach { $0.priority = .defaultHigh }
    NSLayoutConstraint.activate(constraints)
  }
}
