//
//  CollectionView+Helpers.swift
//  CCCalculator
//
//  Created by Amr Hesham on 30/04/2021.
//

import UIKit

// MARK: - CollectionView+Helpers
//
extension UICollectionView {
  
  /// Register cell nib with reuse identifier
  ///
  func registerCellNib<T: UICollectionViewCell>(_: T.Type, reuseIdentifier: String = T.classNameWithoutNamespaces) {
    self.register(T.loadNib(), forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  /// Register cell class with reuse identifier
  ///
  func registerCellClass<T: UICollectionViewCell>(_: T.Type, reuseIdentifier: String = T.classNameWithoutNamespaces) {
    self.register(T.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  /// Dequeue cell with reuse identifier
  ///
  func dequeue<T: UICollectionViewCell>(at indexPath: IndexPath) -> T {
    guard
      let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
    else { fatalError("Could not deque cell with type \(T.self)") }
    
    return cell
  }
  
  /// Register `UICollectionReusableView` with reuse identifier
  ///
  func registerHeaderViewClass<T: UICollectionReusableView>(_: T.Type, reuseIdentifier: String? = nil) {
    let reuseIdentifier = reuseIdentifier ?? T.classNameWithoutNamespaces
    register(
      T.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: reuseIdentifier
    )
  }
  
  /// Dequeue cell with reuse identifier
  ///
  func dequeueHeaderView<T: UICollectionReusableView>(at indexPath: IndexPath) -> T {
    guard let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.classNameWithoutNamespaces, for: indexPath) as? T else {
      fatalError()
    }
    
    return view
  }
}
