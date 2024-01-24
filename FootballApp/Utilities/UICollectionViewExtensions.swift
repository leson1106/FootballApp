//
//  UICollectionViewExtensions.swift
//  FootBallApp
//
//  Created by Son Le on 18/01/2024.
//

import UIKit

extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(type: T.Type = T.self,
                                              at indexPath: IndexPath) -> T? {
        let cell = dequeueReusableCell(withReuseIdentifier: NSStringFromClass(type.self),
                                       for: indexPath) as? T
        return cell
    }

    func register<T: UICollectionViewCell>(type: T.Type = T.self) {
        register(type.self, forCellWithReuseIdentifier: NSStringFromClass(type.self))
    }
}
