//
//  ProgressViewable.swift
//  CCCalculator
//
//  Created by Amr Hesham on 01/05/2021.
//

import Foundation
// MARK: - ProgressViewable
//
protocol ProgressViewable {
    
    /// Default `ProgressType` for loading view.
    var progressType: ProgressViewType { get }
    
    /// Show loading view
    ///
    /// - parameter show: Shows progress view.
    /// - parameter type: set progress view type.
    func shouldShowProgressView(_ show: Bool, type: ProgressViewType)
}
