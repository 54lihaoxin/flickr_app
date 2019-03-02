//
//  SearchPhotoViewController+ViewModel.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/1/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import FlickrFoundation

extension SearchPhotoViewController {
    final class ViewModel {
        enum Text {
            static let title = "FLICKR_APP_NAME".localized()
            static let searchBarPlaceholder = "SEARCH_VIEW.SEARCH_BAR_PLACEHOLDER".localized()
        }

        let photos: [Photo]

        init() {  // TODO
            photos = Array(repeating: Photo(), count: 25)
        }
    }
}
