//
//  PhotoCollectionViewCell.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/1/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import FlickrFoundation
import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    private enum Color {
        static let backgroundColor = UIColor.white
        static let imageViewBackgroundColor = UIColor.lightGray
        static let labelBackgroundColor = UIColor.white.withAlphaComponent(0.7)
    }

    private enum Dimension {
        static let titleLabelHeight: CGFloat = 24
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = Color.imageViewBackgroundColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label =  UILabel(frame: .zero)
        label.backgroundColor = Color.labelBackgroundColor
        label.textAlignment = .center
        return label
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }

    func configure(withPhoto photo: FlickrPhoto) {
        titleLabel.text = photo.title
        if let url = photo.thumbnailURL(forScreenScale: UIScreen.main.scale) {
            imageView.loadImage(fromURL: url)
        } // else fail quietly
    }
}

// MARK: - private

private extension PhotoCollectionViewCell {
    func reset() {
        imageView.image = nil
        titleLabel.text = nil
    }

    func setUp() {
        contentView.backgroundColor = Color.backgroundColor
        setUpImageView()
        setUpTitle()
        reset()
    }

    func setUpImageView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    func setUpTitle() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: Dimension.titleLabelHeight).isActive = true
    }
}
