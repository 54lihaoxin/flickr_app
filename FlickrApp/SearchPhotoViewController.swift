//
//  SearchPhotoViewController.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/1/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import FlickrFoundation
import UIKit

protocol SearchPhotoViewControllerDataSource {
    // TODO
}

final class SearchPhotoViewController: UIViewController {
    enum Color {
        static let backgroundColor = UIColor.white
    }

    enum Dimension {
        static let minimumPhotoCellWidth: CGFloat = 150
        static let padding: CGFloat = 12
    }

    private var viewModel = ViewModel()
    private var photoCellSize = CGSize.zero // update after we know the view dimension

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = self
        searchBar.placeholder = ViewModel.Text.searchBarPlaceholder
        return searchBar
    }()

    private lazy var photoCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(cellType: PhotoCollectionViewCell.self)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updatePhotoCellSize(viewWidth: size.width)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePhotoCellSize(viewWidth: view.window?.frame.width ?? 0)
    }
}

// MARK: - UISearchBarDelegate

extension SearchPhotoViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("TODO: show list of search terms:", SearchHistory.allSearchTerms)
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text {
            SearchHistory.addSearchTerm(text: searchTerm)
        }
        searchBar.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDataSource

extension SearchPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueCell(cellType: PhotoCollectionViewCell.self, for: indexPath)
    }
}

// MARK: - UICollectionViewDelegate

extension SearchPhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let photoCell = cell as? PhotoCollectionViewCell else {
            assertionFailure("\(#function) unexpected cell type \(type(of: cell))")
            return
        }
        let photo = viewModel.photos[indexPath.item]
        photoCell.configure(title: photo.title, photoURL: photo.photoURL)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return photoCellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Dimension.padding,
                            left: Dimension.padding,
                            bottom: Dimension.padding,
                            right: Dimension.padding)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Dimension.padding
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Dimension.padding
    }
}

// MARK: - private

private extension SearchPhotoViewController {
    func setUpView() {
        title = ViewModel.Text.title
        view.backgroundColor = Color.backgroundColor

        setUpSearchBar()
        setUpPhotoCollectionView()
    }

    func setUpSearchBar() {
        view.addSubview(searchBar)
        searchBar.backgroundColor = Color.backgroundColor
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    func setUpPhotoCollectionView() {
        view.addSubview(photoCollectionView)
        photoCollectionView.backgroundColor = Color.backgroundColor
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        photoCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func updatePhotoCellSize(viewWidth: CGFloat) {
        let numberOfCellsPerRow = Int((viewWidth - Dimension.padding) / (Dimension.minimumPhotoCellWidth + Dimension.padding))
        let cellWidth = floor((viewWidth - Dimension.padding) / CGFloat(numberOfCellsPerRow) - Dimension.padding)
        photoCellSize = CGSize(width: cellWidth, height: cellWidth)
        photoCollectionView.collectionViewLayout.invalidateLayout()
    }
}
