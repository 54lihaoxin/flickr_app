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

    private lazy var photoCollectionView = PhotoCollectionView(photos: viewModel.photos, unownedDelegate: self)
    
    private weak var searchHistoryView: TextTableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        registerKeyboardNotifications()
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
        showSearchHistory()
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text {
            SearchHistory.addSearchTerm(text: searchTerm)
        }
        dismissSearchHistory()
        searchBar.resignFirstResponder()
    }
}

// MARK: - PhotoCollectionViewDelegate

extension SearchPhotoViewController: PhotoCollectionViewDelegate {
    var photoCollectionViewPadding: CGFloat {
        return Dimension.padding
    }
    
    var photoCollectionViewCellSize: CGSize {
        return photoCellSize
    }
    
    func photoCollectionView(_ photoCollectionView: PhotoCollectionView, didSelectPhoto photo: Photo) {
        // TODO
        print("didSelectPhoto", photo.title)
    }
}

// MARK: - TextTableViewDelegate

extension SearchPhotoViewController: TextTableViewDelegate {
    func textTableView(_ textTableView: TextTableView, didSelectText text: String) {
        print("didSelect", text)
        dismissSearchHistory()
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

// MARK: - private search history handling

private extension SearchPhotoViewController {
    func showSearchHistory() {
        if let prevSearchHistoryView = searchHistoryView {
            prevSearchHistoryView.removeFromSuperview()
        }

        let newSearchHistoryView = TextTableView(stringArray: SearchHistory.allSearchTerms, unownedDelegate: self)
        self.searchHistoryView = newSearchHistoryView
        view.addSubview(newSearchHistoryView)
        newSearchHistoryView.translatesAutoresizingMaskIntoConstraints = false
        newSearchHistoryView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        newSearchHistoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        newSearchHistoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        newSearchHistoryView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        newSearchHistoryView.alpha = 0
        DispatchQueue.main.async {
            UIView.animate(withDuration: Constant.defaultAnimationDuration) {
                newSearchHistoryView.alpha = 1
            }
        }
    }

    func dismissSearchHistory() {
        guard let searchHistoryView = searchHistoryView else {
            return
        }

        DispatchQueue.main.async {
            UIView.animate(withDuration: Constant.defaultAnimationDuration, animations: {
                searchHistoryView.alpha = 0
            }, completion: { _ in
                searchHistoryView.removeFromSuperview()
            })
        }
    }
}

// MARK: - private keyboard handling

private extension SearchPhotoViewController {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleShowKeyboardNotification(_:)),
                                               name: UIWindow.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleHideKeyboardNotification(_:)),
                                               name: UIWindow.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc func handleShowKeyboardNotification(_ notification: Notification) {
        guard let keyboardEndFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            assertionFailure("\(#function) keyboardEndFrame is nil")
            return
        }
        searchHistoryView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrame.height, right: 0)
    }

    @objc func handleHideKeyboardNotification(_ notification: Notification) {
        searchHistoryView?.contentInset = UIEdgeInsets.zero
    }
}
