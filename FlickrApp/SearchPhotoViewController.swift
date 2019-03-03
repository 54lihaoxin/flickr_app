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
    private enum Color {
        static let backgroundColor = UIColor.white
    }

    private enum Constant {
        static let searchHistoryAnimationDuration: TimeInterval = 0.2
    }

    private enum Dimension {
        static let minimumPhotoCellWidth: CGFloat = 150
        static let padding: CGFloat = 12
    }

    private var viewModel = ViewModel.emptyModel
    private var photoCellSize = CGSize.zero // update after we know the view dimension
    private var previousSearchTerm: String? // put this back to search bar when cancelling the search

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = self
        searchBar.placeholder = ViewModel.Text.searchBarPlaceholder
        searchBar.inputAccessoryView = KeyboardToolbar(unownedDelegate: self)
        return searchBar
    }()
    private lazy var loadingIndicator = UIActivityIndicatorView(style: .gray)
    private lazy var photoCollectionView = PhotoCollectionView(photoDataSource: self.viewModel, unownedDelegate: self)
    private weak var searchHistoryView: TextTableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        registerKeyboardNotifications()
        searchBar.becomeFirstResponder()
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
        previousSearchTerm = searchBar.text
        showSearchHistory()
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchForSearchTerm(searchBar.text ?? "", pageNumber: 1)
    }
}

// MARK: - KeyboardToolbarDelegate

extension SearchPhotoViewController: KeyboardToolbarDelegate {
    func keyboardToolbarDidHitCancelButton(_ keyboardToolbar: KeyboardToolbar) {
        searchBar.text = previousSearchTerm
        previousSearchTerm = nil
        dismissSearchHistory()
    }
}

// MARK: - PhotoCollectionViewDelegate

extension SearchPhotoViewController: PhotoCollectionViewDelegate {
    func photoCollectionView(_ photoCollectionView: PhotoCollectionView, didSelectPhoto photo: FlickrPhoto) {
        guard let url = photo.url else {
            UIAlertController.presentErrorAlert(message: "SEARCH_VIEW.NO_PHOTO_URL_ERROR_MESSAGE".localized(), fromViewController: self)
            return
        }
        FullScreenImageViewController.presentImage(imageURL: url, fromViewController: self)
    }

    func showLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
        }
    }

    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
}

// MARK: - TextTableViewDelegate

extension SearchPhotoViewController: TextTableViewDelegate {
    func textTableView(_ textTableView: TextTableView, didSelectText text: String) {
        searchForSearchTerm(text, pageNumber: 1)
    }
}

// MARK: - private view layout

private extension SearchPhotoViewController {
    func setUpView() {
        title = ViewModel.Text.title
        view.backgroundColor = Color.backgroundColor

        setUpLoadingIndicator()
        setUpSearchBar()
        setUpPhotoCollectionView()
    }

    func setUpLoadingIndicator() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingIndicator)
    }

    func setUpSearchBar() {
        view.addSubview(searchBar)
        searchBar.backgroundColor = Color.backgroundColor
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.inputAccessoryView?.sizeToFit()
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
        let cellDimension = floor((viewWidth - Dimension.padding) / CGFloat(numberOfCellsPerRow) - Dimension.padding)
        let cellSize = CGSize(width: cellDimension, height: cellDimension) // square cell
        photoCollectionView.updateLayoutParameters(padding: Dimension.padding, cellSize: cellSize)
    }
}

// MARK: - private search handling

private extension SearchPhotoViewController {
    func searchForSearchTerm(_ searchTerm: String, pageNumber: Int) {
        dismissSearchHistory()

        guard !searchTerm.isEmpty else {
            return
        }

        searchBar.text = searchTerm
        SearchHistory.shared.addSearchTerm(text: searchTerm)
        viewModel = ViewModel(searchTerm: searchTerm)
        photoCollectionView.updatePhotoDataSource(viewModel)
    }
}

// MARK: - private search history handling

private extension SearchPhotoViewController {
    func showSearchHistory() {
        if let prevSearchHistoryView = searchHistoryView {
            prevSearchHistoryView.removeFromSuperview()
        }

        let newSearchHistoryView = TextTableView(stringArray: SearchHistory.shared.allSearchTerms, unownedDelegate: self)
        self.searchHistoryView = newSearchHistoryView
        view.addSubview(newSearchHistoryView)
        newSearchHistoryView.translatesAutoresizingMaskIntoConstraints = false
        newSearchHistoryView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        newSearchHistoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        newSearchHistoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        newSearchHistoryView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        newSearchHistoryView.alpha = 0
        DispatchQueue.main.async {
            UIView.animate(withDuration: Constant.searchHistoryAnimationDuration) {
                newSearchHistoryView.alpha = 1
            }
        }
    }

    func dismissSearchHistory() {
        searchBar.resignFirstResponder()

        guard let searchHistoryView = searchHistoryView else {
            return
        }

        DispatchQueue.main.async {
            UIView.animate(withDuration: Constant.searchHistoryAnimationDuration, animations: {
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
        let actualKeyboardHeight = keyboardEndFrame.height - view.safeAreaInsets.bottom
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: actualKeyboardHeight, right: 0)
        searchHistoryView?.contentInset = inset
        searchHistoryView?.scrollIndicatorInsets = inset
    }

    @objc func handleHideKeyboardNotification(_ notification: Notification) {
        searchHistoryView?.contentInset = .zero
        searchHistoryView?.scrollIndicatorInsets = .zero
    }
}
