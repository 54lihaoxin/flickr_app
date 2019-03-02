//
//  SearchPhotoViewController+ViewModel.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/1/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import Foundation
import FlickrFoundation

extension SearchPhotoViewController {
    final class ViewModel {
        let title = "FLICKR_APP_NAME".localized()
        let photos: [PhotoItem]

        init() {  // TODO
            photos = Array(repeating: PhotoItem(), count: 25)
        }
    }

    final class PhotoItem { // TODO
        let title = "some title"
        let photoURL = URL(string: "https://farm8.staticflickr.com/7885/46325113415_b0eeaf274b.jpg")! // TODO
    }
}
