//
//  AdView.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 09/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import UIKit

class AdView: UIView {

    var ad: Ad? {
        didSet {
            imageView.image = ad?.smallImage ?? UIImage(named: "no-image-placeholder")
            idLabel.text = ad?.id != nil ? "\(ad!.id)" : ""
            categoryLabel.text = ad?.category.name
            titleLabel.text = ad?.title
            descLabel.text = ad?.description
            priceLabel.text = ad?.formattedPrice
            creationLabel.text = ad?.formattedDate
            urgentImageView.isHidden = ad?.isUrgent == false
        }
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var urgentImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "warning"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .primary
        return imageView
    }()

    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .textPrimary
        return label
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .textPrimary
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .textPrimary
        return label
    }()

    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .textPrimary
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .primary
        return label
    }()

    private lazy var creationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .textPrimary
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(urgentImageView)
        addSubview(idLabel)
        addSubview(categoryLabel)
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(priceLabel)
        addSubview(creationLabel)

        NSLayoutConstraint.activate([
            // imageView
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            // urgentImageView
            urgentImageView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            urgentImageView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            // idLabel
            idLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            idLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            idLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.trailingAnchor),
            // categoryLabel
            categoryLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 4),
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.trailingAnchor),
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.trailingAnchor),
            // creationLabel
            creationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            creationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            // priceLabel
            priceLabel.topAnchor.constraint(equalTo: creationLabel.topAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            // descLabel
            descLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            descLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            descLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
