//
//  SkontoAppliedAmountView.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//

import UIKit
import GiniCaptureSDK

public class SkontoAppliedAmountView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedStringPreferredGiniBankFormat("ginibank.skonto.info.amount.title",
                                                              comment: "Betrag nach Abzug")
        label.font = configuration.textStyleFonts[.footnote]
        // TODO: in some places invertive color is dark7
        label.textColor = GiniColor(light: .GiniBank.dark6, dark: .GiniBank.light6).uiColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.text = "999,00"
        textField.textColor = GiniColor(light: .GiniBank.dark1, dark: .GiniBank.light1).uiColor()
        textField.font = configuration.textStyleFonts[.body]
        textField.borderStyle = .none
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "EUR"
        // TODO: we have dark7 but doesn't have light7 and project has no dark7 setups before Skonto
        label.textColor = GiniColor(light: .GiniBank.dark7, dark: .GiniBank.light6).uiColor()
        label.font = configuration.textStyleFonts[.body]
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.borderColor = GiniColor(light: .GiniBank.light3, dark: .GiniBank.dark4).uiColor().cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let configuration = GiniBankConfiguration.shared

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = GiniColor(light: .GiniBank.light1, dark: .GiniBank.dark3).uiColor()
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(textField)
        containerView.addSubview(currencyLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),

            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),

            currencyLabel.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            currencyLabel.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 10),
            currencyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
    }
}
