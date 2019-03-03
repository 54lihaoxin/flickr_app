//
//  FullScreenImageViewController.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/2/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import UIKit

final class FullScreenImageViewController: UIViewController {
    private enum Dimension {
        static let dismissButtonDimension: CGFloat = 44
        static let padding: CGFloat = 16
    }

    private enum Font {
        static let dismissButtonFont = UIFont.systemFont(ofSize: 32)
    }

    private let imageURL: URL

    private lazy var dismissButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.titleLabel?.font = Font.dismissButtonFont
        button.setTitle("x", for: .normal)
        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    init(imageURL: URL) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        imageView.loadImage(fromURL: imageURL)
    }
}

// MARK: - private

private extension FullScreenImageViewController {
    func setUp() {
        setUpImageView()
        setUpDismissButton()
    }

    func setUpImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func setUpDismissButton() {
        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.widthAnchor.constraint(equalToConstant: Dimension.dismissButtonDimension).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: Dimension.dismissButtonDimension).isActive = true
        dismissButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Dimension.padding).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Dimension.padding).isActive = true
    }

    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
