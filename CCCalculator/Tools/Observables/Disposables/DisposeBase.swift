//
//  DisposeBase.swift
//  CCCalculator
//
//  Created by Amr Hesham on 21/04/2021.
//

import Foundation

/// Base class for all disposables.
public class DisposeBase {
  init() {
    #if TRACE_RESOURCES
    _ = Resources.incrementTotal()
    #endif
  }
  
  deinit {
    #if TRACE_RESOURCES
    _ = Resources.decrementTotal()
    #endif
  }
}
