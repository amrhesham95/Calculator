//
//  CurrencyConverterViewControllerTests.swift
//  CCCalculatorTests
//
//  Created by Amr Hesham on 01/05/2021.
//

import XCTest
@testable import CCCalculator

// MARK: - CurrencyConverterViewControllerTests
//
class CurrencyConverterViewControllerTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: CurrencyConverterViewController!
  
  // MARK: - LifeCycle
  
  override func setUp() {
    super.setUp()
    
    sut = CurrencyConverterViewController()
    sut.loadViewIfNeeded()
  }
  
  override func tearDown() {
    super.tearDown()
    sut = nil
  }
  
  // MARK: - Tests
  func testCurrencyConverterViewControllerTest_whenCreated_textFieldKeyboardTypeIsNumber() {
    
    // Then
    XCTAssertEqual(sut.textField.keyboardType, .asciiCapableNumberPad, "keyboard type isn't set correctly")
  }

  func testCurrencyConverterViewControllerTest_whenCreated_convertButtonIsNotEnabled() {
    
    // Then
    XCTAssertFalse(sut.convertButton.isEnabled, "Convert button should be disabled")
  }
  
  func testCurrencyConverterViewControllerTest_whenTextFieldIsEmpty_convertButtonIsNotEnabled() {
    
    // When
    sut.textField.text = ""
    sut.textField.sendActions(for: .editingChanged)
    
    // Then
    XCTAssertFalse(sut.convertButton.isEnabled, "Convert button should be disabled")
  }
  
  func testCurrencyConverterViewControllerTest_whenTextFieldHasValidData_convertButtonIsEnabled() {
    
    // When
    sut.textField.text = "22"
    sut.textField.sendActions(for: .editingChanged)
    
    // Then
    XCTAssertTrue(sut.convertButton.isEnabled, "Convert button should be enabled")
  }
  
  func testCurrencyConverterViewControllerTest_whenConvertButtonPressed_progressViewIsShown() {
    
    // Given
    sut.textField.text = "22"

    // When
    sut.convertButton.sendActions(for: .touchUpInside)
    RunLoop.current.run(until: Date())
    let progressView = AppDelegate.shared.window?.subviews.first(where: { $0 as? InProgressView != nil })
    
    // Then
    XCTAssertNotNil(progressView, "Progress view isn't shown")
  }
}
  
