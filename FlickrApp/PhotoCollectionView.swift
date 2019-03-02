//
//  PhotoCollectionView.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/2/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import UIKit

protocol PhotoCollectionViewDelegate: class {
    var photoCollectionViewPadding: CGFloat { get }
    var photoCollectionViewCellSize: CGSize { get }
    func photoCollectionView(_ photoCollectionView: PhotoCollectionView, didSelectPhoto photo: Photo)
}

final class PhotoCollectionView: UICollectionView {
    private let photos: [Photo]
    private unowned let photoCollectionViewDelegate: PhotoCollectionViewDelegate

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    init(photos: [Photo], unownedDelegate: PhotoCollectionViewDelegate) {
        self.photos = photos
        self.photoCollectionViewDelegate = unownedDelegate
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        dataSource = self
        delegate = self
        registerCell(cellType: PhotoCollectionViewCell.self)
    }
}

// MARK: - UICollectionViewDataSource

extension PhotoCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueCell(cellType: PhotoCollectionViewCell.self, for: indexPath)
    }
}

// MARK: - UICollectionViewDelegate

extension PhotoCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let photoCell = cell as? PhotoCollectionViewCell else {
            assertionFailure("\(#function) unexpected cell type \(type(of: cell))")
            return
        }
        let photo = photos[indexPath.item]
        photoCell.configure(title: photo.title, photoURL: photo.photoURL)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoCollectionViewDelegate.photoCollectionView(self, didSelectPhoto: photos[indexPath.item])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PhotoCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return photoCollectionViewDelegate.photoCollectionViewCellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: photoCollectionViewDelegate.photoCollectionViewPadding,
                            left: photoCollectionViewDelegate.photoCollectionViewPadding,
                            bottom: photoCollectionViewDelegate.photoCollectionViewPadding,
                            right: photoCollectionViewDelegate.photoCollectionViewPadding)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return photoCollectionViewDelegate.photoCollectionViewPadding
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return photoCollectionViewDelegate.photoCollectionViewPadding
    }
}
