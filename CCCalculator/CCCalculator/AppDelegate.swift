//
//  AppDelegate.swift
//  CCCalculator
//
//  Created by Amr Hesham on 21/04/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  /// UIWindow
  ///
  var window: UIWindow?
  
  /// Coordinates app navigation.
  ///
  var appCoordinator: AppCoordinator? {
    return AppCoordinator()
  }
  
  
  /// Tab Bar Controller
  ///
  var tabBarController: MainTabBarController? {
    return window?.rootViewController as? MainTabBarController
  }
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // Setup the Interface!
    setupMainWindow()
    
    return true
  }
}

// MARK: - Initialization Methods
//
private extension AppDelegate {
  
  /// Sets up the main UIWindow instance wth app coordinator.
  ///
  func setupMainWindow() {
    let window = UIWindow()
    window.makeKeyAndVisible()
    window.rootViewController = appCoordinator?.tabBarController
    self.window = window
    
  }
}

