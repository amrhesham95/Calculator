//
//  AppTab.swift
//  CCCalculator
//
//  Created by Amr Hesham on 21/04/2021.
//

import Foundation

/// Enum representing the individual tabs
///
enum AppTab {
    
    /// Caluclator Tab
    ///
    case calculator
    
    /// Currency converter Tab
    ///
    case currencyConverter
}

extension AppTab {
    /// Initializes a tab with the visible tab index.
    ///
    /// - Parameters:
    ///   - visibleIndex: the index of visible tabs on the tab bar
    init(visibleIndex: Int) {
        let tabs = AppTab.visibleTabs()
        self = tabs[visibleIndex]
    }
    
    /// Returns the visible tab index.
    func visibleIndex() -> Int {
        let tabs = AppTab.visibleTabs()
        guard let tabIndex = tabs.firstIndex(where: { $0 == self }) else {
            assertionFailure("Trying to get the visible tab index for tab \(self) while the visible tabs are: \(tabs)")
            return .zero
        }
        return tabIndex
    }
    
    static func visibleTabs() -> [AppTab] {
        return [.calculator, .currencyConverter]
    }
}
