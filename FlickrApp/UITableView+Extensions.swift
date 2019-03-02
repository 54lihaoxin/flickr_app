//
//  UITableView+Extensions.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/2/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(cellType: T.Type,
                                          withReuseIdentifier identifier: String = T.typeDescription) {
        register(T.self, forCellReuseIdentifier: identifier)
    }

    func dequeueCell<T: UITableViewCell>(cellType: T.Type,
                                         withReuseIdentifier identifier: String = T.typeDescription,
                                         for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("\(#function) failed to dequeue cell for reuseIdentifier [\(identifier)]")
        }
        return cell
    }
}
