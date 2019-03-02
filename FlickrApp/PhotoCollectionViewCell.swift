//
//  PhotoCollectionViewCell.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/1/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import Foundation
import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        reset()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }

    func configure(title: String, photoURL: URL) {
        // TODO
        print("\(#function) \(photoURL) \(title)")
    }
}

// MARK: - private

private extension PhotoCollectionViewCell {
    func reset() {
        contentView.backgroundColor = .red
    }
}
