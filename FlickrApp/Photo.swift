//
//  Photo.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/2/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import FlickrFoundation

struct Photo {
    let title: String
    let url: URL

    init(title: String, url: URL) {
        self.title = title
        self.url = url
    }

    init?(flickrPhoto: FlickrPhoto) {
        guard let url = flickrPhoto.sourceURL else {
            return nil
        }
        self.init(title: flickrPhoto.title, url: url)
    }
}
