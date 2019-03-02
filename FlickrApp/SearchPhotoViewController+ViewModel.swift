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

        let searchTerm: String
        let pageNumber: Int
        let photos: [Photo]
        let totalPageCount: Int

        static var emptyModel: ViewModel {
            return ViewModel(searchTerm: "", pageNumber: 1, photos: [], totalPageCount: 0)
        }

        init(searchTerm: String, pageNumber: Int, photos: [Photo], totalPageCount: Int) {
            self.searchTerm = searchTerm
            self.pageNumber = pageNumber
            self.photos = photos
            self.totalPageCount = totalPageCount
        }
    }
}
