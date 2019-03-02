//
//  ImageCache.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/1/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import UIKit

/**
 This is a simply in-memory image cache.
 */
final class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    func image(forURL url: URL) -> UIImage? {
        return cache.object(forKey: url.cacheKey)
    }

    func cacheImage(_ image: UIImage, forURL url: URL) {
        cache.setObject(image, forKey: url.cacheKey)
    }
}

private extension URL {
    var cacheKey: NSString {
        return absoluteString as NSString
    }
}
