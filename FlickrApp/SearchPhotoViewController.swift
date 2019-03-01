//
//  SearchPhotoViewController.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/1/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import FlickrFoundation
import UIKit

final class SearchPhotoViewController: UIViewController {
    enum Color {
        static let backgroundColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
}

private extension SearchPhotoViewController {
    func setUpView() {
        title = "FLICKR_APP_NAME".localized()
        view.backgroundColor = Color.backgroundColor
    }
}
