//
//  UIImage+Extensions.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/1/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import UIKit

extension UIImageView {
    private enum AssociatedObjectKey {
        static var imageDataTaskIDContext = 0
    }

    private var imageDataTaskID: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectKey.imageDataTaskIDContext) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectKey.imageDataTaskIDContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /**
     `completion` indicates whether the image is loaded successfully.
     */
    func loadImage(fromURL url: URL, completion: @escaping (Bool) -> Void) {
        if let image = ImageCache.shared.image(forURL: url) {
            DispatchQueue.main.async {
                self.image = image
                completion(true)
            }
            return
        }

        let dataTaskID = url.absoluteString
        imageDataTaskID = dataTaskID

        URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            guard let data = data,
                !data.isEmpty,
                let image = UIImage(data: data) else {
                    completion(false)
                    return
            }
            ImageCache.shared.cacheImage(image, forURL: url)

            guard let self = self,
                self.imageDataTaskID == dataTaskID else {
                    completion(false)
                    return
            }
            DispatchQueue.main.async {
                self.image = image
                completion(true)
            }
        }.resume()
    }
}
