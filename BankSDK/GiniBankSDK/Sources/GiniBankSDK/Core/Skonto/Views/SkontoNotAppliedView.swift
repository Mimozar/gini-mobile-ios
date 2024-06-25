//
//  SkontoNotAppliedView.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//

import UIKit
import GiniCaptureSDK

class SkontoNotAppliedView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        // TODO: Localization
        label.text = NSLocalizedStringPreferredGiniBankFormat("ginibank.skonto.notapplied.title",
                                                              comment: "Ohne Skonto")
        label.textColor = GiniColor(light: .GiniBank.dark1, dark: .GiniBank.light1).uiColor()
        label.font = configuration.textStyleFonts[.bodyBold]
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(
            string: NSLocalizedStringPreferredGiniBankFormat("ginibank.skonto.info.status",
                                                             comment: "• Aktiviert"),
            attributes: [NSAttributedString.Key.font: configuration.textStyleFonts[.footnoteBold]!,
                         NSAttributedString.Key.foregroundColor: GiniColor(light: .GiniBank.success3,
                                                                           dark: .GiniBank.success3).uiColor()
                        ])
        label.attributedText = attributedString
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var amountView: UIView = {
        return SkontoNotAppliedAmountView(viewModel: viewModel)
    }()

    private let configuration = GiniBankConfiguration.shared

    private var viewModel: SkontoViewModel

    public init(viewModel: SkontoViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = GiniColor(light: .GiniBank.light1, dark: .GiniBank.dark3).uiColor()
        addSubview(titleLabel)
        addSubview(statusLabel)
        addSubview(amountView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalPadding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            statusLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor,
                                                 constant: Constants.statusLabelHorizontalPadding),

            amountView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.verticalPadding),
            amountView.bottomAnchor.constraint(equalTo: bottomAnchor),
            amountView.leadingAnchor.constraint(equalTo: leadingAnchor),
            amountView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

private extension SkontoNotAppliedView {
    enum Constants {
        static let statusLabelHorizontalPadding: CGFloat = 4
        static let verticalPadding: CGFloat = 12
    }
}
