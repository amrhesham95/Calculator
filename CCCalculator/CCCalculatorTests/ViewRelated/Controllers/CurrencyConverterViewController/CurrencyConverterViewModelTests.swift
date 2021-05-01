//
//  CurrencyConverterViewModelTests.swift
//  CCCalculatorTests
//
//  Created by Amr Hesham on 01/05/2021.
//

import XCTest
@testable import CCCalculator

// MARK: - CurrencyConverterViewModelTests
//
class CurrencyConverterViewModelTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: CurrencyConverterViewModel!
  let disposeBag = DisposeBag()
  /// For test binding on state and viewmodel state
  ///
  private var state: State!


  // MARK: - LifeCycle
  
  override func setUp() {
    super.setUp()
    
    sut = CurrencyConverterViewModel(store: MockCurrencyStore())
  }
  
  override func tearDown() {
    super.tearDown()
    
    state = nil
    sut = nil
  }
  
  // MARK: - Given
  func configureBindingOnState() {
    sut.state.subscribe { state in
      self.state = state
    }.disposed(by: disposeBag)
  }

  
  // MARK: - Tests
  
  func testCurrencyConverterViewModel_whenConvertCalledWithSuccessResponse_stateIsSetToSuccess() {
    
    // Given
    configureBindingOnState()
    
    // When
    sut.convert()
    

    // Then
    XCTAssertEqual(state, .success, "State should be success")
  }
  
  func testCurrencyConverterViewModel_whenConvertCalledWithSuccessResponse_postsNotificationSuccessfully() {
    
    // Given
    let expectation = self.expectation(forNotification: .DidConvertCurrencySuccessfully, object: nil, handler: nil)
    sut.converterInputValueSubject.send("22")
    // When
    sut.convert()

    // Then
    wait(for: [expectation], timeout: 2)
  }
  
  func testCurrencyConverterViewModel_whenDidCalculatorTextFieldDidChangeNotificationFired_updatesInputSubjectSuccessfully() {
    
    // Given
    let _ = self.expectation(forNotification: .CalculatorTextFieldDidChange, object: nil, handler: nil)
    let dataDictionary: [String: Double] = [Constants.calculatorTextFieldValue: 22]
    NotificationCenter.default.post(name: .CalculatorTextFieldDidChange, object: nil, userInfo: dataDictionary)
    waitForExpectations(timeout: 2) { [weak self] _ in
      // Then
      XCTAssertEqual(self?.sut.converterInputValueSubject.value, "22.0")
    }
  }
  
  func testCurrencyConverterViewModel_whenCalculateCall_postsNotificationSuccessfully() {
    
    // Given
    let expectation = self.expectation(forNotification: .DidConvertCurrencySuccessfully, object: nil, handler: nil)
    sut.converterInputValueSubject.send("22")
    // When
    sut.convert()

    // Then
    wait(for: [expectation], timeout: 2)
  }

}
