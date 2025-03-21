//
//  PoweredByGiniView.swift
//  GiniMerchantSDK
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//


import UIKit
import GiniUtilites

public final class PoweredByGiniView: UIView {
    private let viewModel: PoweredByGiniViewModel
    private let mainContainer = EmptyView()

    private lazy var poweredByGiniLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.strings.poweredByGiniText
        label.textColor = viewModel.configuration.poweredByGiniLabelAccentColor
        label.font = viewModel.configuration.poweredByGiniLabelFont
        label.numberOfLines = Constants.textNumberOfLines
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    
    private lazy var giniImageView: UIImageView = {
        let imageView = UIImageView(image: viewModel.configuration.giniIcon)
        imageView.frame = CGRect(x: 0, y: 0, width: Constants.widthGiniLogo, height: Constants.heightGiniLogo)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public init(viewModel: PoweredByGiniViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        mainContainer.addSubview(poweredByGiniLabel)
        mainContainer.addSubview(giniImageView)
        self.addSubview(mainContainer)
        
        NSLayoutConstraint.activate([
            mainContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainContainer.topAnchor.constraint(equalTo: topAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: giniImageView.trailingAnchor),
            giniImageView.leadingAnchor.constraint(equalTo: poweredByGiniLabel.trailingAnchor, constant: Constants.spacingImageText),
            poweredByGiniLabel.centerYAnchor.constraint(equalTo: giniImageView.centerYAnchor),
            poweredByGiniLabel.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            giniImageView.heightAnchor.constraint(equalToConstant: giniImageView.frame.height),
            giniImageView.widthAnchor.constraint(equalToConstant: giniImageView.frame.width),
            giniImageView.centerYAnchor.constraint(equalTo: mainContainer.centerYAnchor)
        ])
    }
}

extension PoweredByGiniView {
    private enum Constants {
        static let imageTopBottomPadding = 3.0
        static let spacingImageText = 4.0
        static let widthGiniLogo = 28.0
        static let heightGiniLogo = 18.0
        static let textNumberOfLines = 1
    }
}
