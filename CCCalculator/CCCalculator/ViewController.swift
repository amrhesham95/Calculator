//
//  ViewController.swift
//  CCCalculator
//
//  Created by Amr Hesham on 21/04/2021.
//

import UIKit

// MARK: - ViewController
//
class ViewController: UIViewController {
  
  // MARK: - Properties
  
  /// DisposeBag
  ///
  let disposeBag = DisposeBag()
  
  /// Notice Presenter using global `ServiceLocator.noticePresenter`
  /// For in view notice, create other property instead.
  ///
//  private var noticePresenter: NoticePresenter {
//    return ServiceLocator.noticePresenter
//  }
}

//// MARK: - View's Configurations
////
//extension ViewController {
//
//  /// Configure view's background color etc...
//  ///
//  /// - Note: Here we are removing the background color because we need background image to be shown.
//  ///
//  private func configureMainView() {
//    view.clearBackgroundColor()
//  }
//}

// MARK: - ViewModel + State Binding Helpers
//
extension ViewController {
  
  /// Bind loading state to ViewModel type
  ///
  /// - Parameter viewModel: ViewModel
  ///
  func bindLoadingState(to viewModel: ViewModel) {
    viewModel.state.subscribe { [weak self] state in
      guard let self = self else { return }
      self.shouldShowProgressView(state == .loading, type: self.progressType)
    }.disposed(by: disposeBag)
  }
  
  /// Bind error state to ViewModel type
  ///
  /// - Parameter viewModel: ViewModel
  ///
  func bindErrorState(to viewModel: ViewModel) {
    return viewModel.state.subscribe { [weak self] state in
      guard let self = self else { return }
      if case .failure(let error) = state {
        let alertController =  UIAlertController(title: "Conversion Failed", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
      }
    }.disposed(by: disposeBag)
  }
}
