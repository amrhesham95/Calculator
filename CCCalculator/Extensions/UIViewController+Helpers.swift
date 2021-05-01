//
//  UIViewController+Helpers.swift
//  CCCalculatorTests
//
//  Created by Amr Hesham on 01/05/2021.
//

import UIKit

extension UIViewController {
  
  func setDoneOnKeyboardTo(_ textField: UITextField) {
      let keyboardToolbar = UIToolbar()
      keyboardToolbar.sizeToFit()
      let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
      let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
      keyboardToolbar.items = [flexBarButton, doneBarButton]
      textField.inputAccessoryView = keyboardToolbar
  }

  @objc func dismissKeyboard() {
      view.endEditing(true)
  }
}

