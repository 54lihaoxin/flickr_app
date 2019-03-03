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

        private let keywordSearchManager: KeywordSearchManager

        static var emptyModel: ViewModel {
            return ViewModel(searchTerm: "")
        }

        var searchTerm: String {
            return keywordSearchManager.searchTerm
        }

        init(searchTerm: String) {
            keywordSearchManager = KeywordSearchManager(searchTerm: searchTerm)
        }
    }
}

extension SearchPhotoViewController.ViewModel: PhotoCollectionViewDataSource {
    var isFetchInProgress: Bool {
        return keywordSearchManager.isFetchInProgress
    }

    var fetchedPhotoCount: Int {
        return keywordSearchManager.photos.count
    }

    var totalNumberOfPhotos: Int {
        return keywordSearchManager.totalResultCount
    }

    func fetchMorePhotos(completion: @escaping (Bool) -> Void) {
        keywordSearchManager.fetchMorePhotos { result in
            switch result {
            case .success:
                completion(true)
            case let .failure(errorMessage):
                completion(false)
                guard let presentingViewController =  AppDelegate.current?.window.rootViewController else {
                    print("\(#function) error: \(errorMessage)")
                    return
                }
                UIAlertController.presentErrorAlert(message: errorMessage, fromViewController: presentingViewController)
            }
        }
    }

    func photo(at index: Int) -> FlickrPhoto {
        return keywordSearchManager.photos[index]
    }
}
