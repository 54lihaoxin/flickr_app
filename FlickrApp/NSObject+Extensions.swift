//
//  NSObject+Extensions.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/1/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import Foundation

extension NSObject {
    static var typeDescription: String {
        return String(describing: type(of: self))
    }
}
