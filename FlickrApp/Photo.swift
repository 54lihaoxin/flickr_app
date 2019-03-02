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
    let photoURL: URL

    // TODO
    init(title: String = "some title",
         photoURL: URL = URL(string: "https://farm8.staticflickr.com/7885/46325113415_b0eeaf274b.jpg")!) {
        self.title = title
        self.photoURL = photoURL
    }

    init?(flickrPhoto: FlickrPhoto) {
        guard let url = flickrPhoto.sourceURL else {
            return nil
        }
        self.init(title: flickrPhoto.title, photoURL: url)
    }
}
