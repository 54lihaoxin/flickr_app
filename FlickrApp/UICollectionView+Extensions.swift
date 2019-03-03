//
//  UICollectionView+Extensions.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/1/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import UIKit

extension UICollectionView {
    var isScrolling: Bool {
        return self.isDragging || self.isDecelerating
    }

    func registerCell<T: UICollectionViewCell>(cellType: T.Type,
                                               withReuseIdentifier identifier: String = T.typeDescription) {
        register(T.self, forCellWithReuseIdentifier: identifier)
    }

    func dequeueCell<T: UICollectionViewCell>(cellType: T.Type,
                                              withReuseIdentifier identifier: String = T.typeDescription,
                                              for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("\(#function) failed to dequeue cell for reuseIdentifier [\(identifier)]")
        }
        return cell
    }
}
