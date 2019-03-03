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
    func photoCollectionView(_ photoCollectionView: PhotoCollectionView, didSelectPhoto photo: FlickrPhoto)
}

final class PhotoCollectionView: UICollectionView {
    private var photoDataSource: PhotoCollectionViewDataSource
    private unowned let photoCollectionViewDelegate: PhotoCollectionViewDelegate

    private var padding: CGFloat = 0
    private var cellSize: CGSize = .zero

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    init(photoDataSource: PhotoCollectionViewDataSource, unownedDelegate: PhotoCollectionViewDelegate) {
        self.photoDataSource = photoDataSource
        self.photoCollectionViewDelegate = unownedDelegate
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        dataSource = self
        delegate = self
        prefetchDataSource = self
        registerCell(cellType: PhotoCollectionViewCell.self)
    }

    func updateLayoutParameters(padding: CGFloat, cellSize: CGSize) {
        guard self.padding != padding, self.cellSize != cellSize else {
            return
        }
        self.padding = padding
        self.cellSize = cellSize
        collectionViewLayout.invalidateLayout()
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

            DispatchQueue.main.async {
                if oldPhotoCount == 0 {
                    self.reloadData()
                } else {
                    self.reloadData(oldPhotoCount: oldPhotoCount,
                                    newPhotoCount: photoDataSource.fetchedPhotoCount)
                }
            }
        }
    }
}

extension PhotoCollectionView: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let maxIndex = indexPaths.reduce(0) { max($0, $1.item) }
        guard photoDataSource.fetchedPhotoCount <= maxIndex else {
            return
        }
        fetchMoreItems()
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
        guard indexPath.item < photoDataSource.fetchedPhotoCount else {
            return
        }
        photoCell.configure(withPhoto: photoDataSource.photo(at: indexPath.item))
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
        return cellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
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
            guard !indexPathsToReload.isEmpty else {
                return
            }
            self.reloadItems(at: indexPathsToReload)
        }
    }
}
