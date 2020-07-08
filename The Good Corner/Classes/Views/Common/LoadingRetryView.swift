//
//  LoadingRetryView.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 08/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import UIKit

class LoadingRetryView: UIView {

    var state: State = .none {
        didSet {
            guard oldValue != state else { return }
            updateToCurrentState()
        }
    }

    var retryTitle: String? {
        didSet {
            retryButton.setTitle(retryTitle, for: .normal)
        }
    }
    var retryAction: (() -> ())?

    private lazy var spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        return spinner
    }()

    private lazy var errorView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [errorLabel, retryButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: leadingAnchor, multiplier: 1)
        ])
        return stackView
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightText
        button.addTarget(self, action: #selector(retryPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        backgroundColor = UIColor.semiTransparentBackground
    }

    private func updateToCurrentState() {
        switch state {
        case .none:
            isHidden = true
            spinnerView.stopAnimating()
            errorView.isHidden = true
        case .loading:
            isHidden = false
            spinnerView.startAnimating()
            errorView.isHidden = true
        case .error(message: let message):
            isHidden = false
            spinnerView.stopAnimating()
            errorView.isHidden = false
            errorLabel.text = message
        }
    }

    @objc private func retryPressed(_ sender: Any) {
        retryAction?()
    }

}

// MARK: - Nested Types
extension LoadingRetryView {
    enum State: Equatable {
        case none
        case loading
        case error(message: String?)

        static func == (lhs: LoadingRetryView.State, rhs: LoadingRetryView.State) -> Bool {
            switch (lhs, rhs) {
            case (.none, .none), (.loading, .loading):
                return true
            case let (.error(lMessage), .error(rMessage)) where lMessage == rMessage:
                return true
            default:
                return false
            }
        }
    }
}
