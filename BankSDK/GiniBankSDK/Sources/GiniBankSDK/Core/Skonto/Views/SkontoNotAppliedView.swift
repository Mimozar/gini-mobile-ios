//
//  SkontoNotAppliedView.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//

import UIKit

class SkontoNotAppliedView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        let title = NSLocalizedStringPreferredGiniBankFormat("ginibank.skonto.notapplied.title",
                                                             comment: "Without Skonto discount")
        label.text = title
        label.accessibilityValue = title
        label.textColor = .giniColorScheme().text.primary.uiColor()
        label.font = configuration.textStyleFonts[.bodyBold]
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        let title = NSLocalizedStringPreferredGiniBankFormat("ginibank.skonto.info.status",
                                                             comment: "• Active")
        label.text = title
        label.accessibilityValue = title
        label.font = configuration.textStyleFonts[.footnoteBold]
        label.textColor = UIColor.giniColorScheme().text.status.uiColor()
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var amountView: SkontoNotAppliedAmountView = {
        return SkontoNotAppliedAmountView(viewModel: viewModel)
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, statusLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Constants.stackviewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let configuration = GiniBankConfiguration.shared

    private var viewModel: SkontoViewModel

    init(viewModel: SkontoViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .giniColorScheme().bg.surface.uiColor()
        addSubview(stackView)
        addSubview(amountView)
        setupConstraints()
        bindViewModel()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalPadding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            amountView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Constants.verticalPadding),
            amountView.bottomAnchor.constraint(equalTo: bottomAnchor),
            amountView.leadingAnchor.constraint(equalTo: leadingAnchor),
            amountView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func bindViewModel() {
        configure()
        viewModel.addStateChangeHandler { [weak self] in
            guard let self else { return }
            self.configure()
        }
    }

    private func configure() {
        statusLabel.isHidden = viewModel.isSkontoApplied
    }
}

private extension SkontoNotAppliedView {
    enum Constants {
        static let stackviewSpacing: CGFloat = 4
        static let verticalPadding: CGFloat = 12
    }
}
