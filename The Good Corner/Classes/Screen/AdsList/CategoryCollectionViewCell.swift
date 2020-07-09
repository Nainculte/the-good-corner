//
//  CategoryCollectionViewCell.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 08/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.layer.cornerRadius = 4
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.primary.cgColor
        contentView.addSubview(titleLabel)

        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .primary
        selectedBackgroundView?.layer.cornerRadius = 4

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    static let identifier = "CategoryCollectionViewCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    func setupWithCategory(_ category: Category) {
        titleLabel.text = category.name
    }

}
