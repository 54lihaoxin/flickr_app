//
//  PhotoCollectionView.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/2/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import FlickrFoundation
import UIKit

protocol PhotoCollectionViewDataSource: class {
    var searchTerm: String { get }
    var isFetchInProgress: Bool { get }
    var fetchedPhotoCount: Int { get }
    var totalNumberOfPhotos: Int { get }
    func fetchMorePhotos(completion: @escaping (Bool) -> Void)
    func photo(at index: Int) -> FlickrPhoto
}

protocol PhotoCollectionViewDelegate: class {
    var photoCollectionViewPadding: CGFloat { get }
    var photoCollectionViewCellSize: CGSize { get }
    func photoCollectionView(_ photoCollectionView: PhotoCollectionView, didSelectPhoto photo: FlickrPhoto)
}

final class PhotoCollectionView: UICollectionView {
    private var photoDataSource: PhotoCollectionViewDataSource
    private unowned let photoCollectionViewDelegate: PhotoCollectionViewDelegate

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    init(photoDataSource: PhotoCollectionViewDataSource, unownedDelegate: PhotoCollectionViewDelegate) {
        self.photoDataSource = photoDataSource
        self.photoCollectionViewDelegate = unownedDelegate
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        dataSource = self
        delegate = self
        registerCell(cellType: PhotoCollectionViewCell.self)
    }

    func updatePhotoDataSource(_ photoDataSource: PhotoCollectionViewDataSource) {
        self.photoDataSource = photoDataSource

        DispatchQueue.main.async {
            self.contentOffset = .zero
            self.reloadData()
        }

        let searchTerm = photoDataSource.searchTerm
        let oldPhotoCount = photoDataSource.fetchedPhotoCount
        photoDataSource.fetchMorePhotos { [weak self] successful in
            guard let self = self,
                successful,
                searchTerm == self.photoDataSource.searchTerm else {
                return
            }

            self.reloadData(oldPhotoCount: oldPhotoCount,
                            newPhotoCount: photoDataSource.fetchedPhotoCount)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension PhotoCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoDataSource.totalNumberOfPhotos
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

        if indexPath.item < photoDataSource.fetchedPhotoCount {
            photoCell.configure(withPhoto: photoDataSource.photo(at: indexPath.item))
        } else { // need to fetch data
            DispatchQueue.global(qos: .userInitiated).async {
                self.fetchMoreItems()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < photoDataSource.fetchedPhotoCount else {
            return
        }
        photoCollectionViewDelegate.photoCollectionView(self, didSelectPhoto: photoDataSource.photo(at: indexPath.item))
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

// MARK: - private

extension PhotoCollectionView {
    func fetchMoreItems() {
        guard !photoDataSource.isFetchInProgress else {
            return
        }

        let searchTerm = photoDataSource.searchTerm
        let oldPhotoCount = photoDataSource.fetchedPhotoCount
        photoDataSource.fetchMorePhotos { [weak self] successful in
            guard let self = self,
                successful,
                searchTerm == self.photoDataSource.searchTerm else {
                    return
            }
            self.reloadData(oldPhotoCount: oldPhotoCount,
                            newPhotoCount: self.photoDataSource.fetchedPhotoCount)
        }
    }

    func reloadData(oldPhotoCount: Int, newPhotoCount: Int) {
        print("\(#function) reload range: [\(oldPhotoCount), \(newPhotoCount)), total: \(photoDataSource.totalNumberOfPhotos)")

        guard oldPhotoCount < newPhotoCount else {
            return
        }

        DispatchQueue.main.async {
            let indexPathsToReload = self.indexPathsForVisibleItems.filter({
                oldPhotoCount <= $0.item && $0.item < newPhotoCount
            })

            print("\(#function) actual reload item count: \(indexPathsToReload.count)")
            if indexPathsToReload.isEmpty {
                self.reloadData()
            } else {
                self.reloadItems(at: indexPathsToReload)
            }
        }
    }
}
