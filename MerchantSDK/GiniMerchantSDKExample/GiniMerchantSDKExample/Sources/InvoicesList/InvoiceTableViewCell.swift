//
//  InvoiceTableViewCell.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//


import UIKit

final class InvoiceTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: InvoiceTableViewCell.self)

    private let recipientLabel = UILabel()
    private let ibanLabel = UILabel()
    private let amountLabel = UILabel()

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [verticalStackView, amountLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = Constants.horizontalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recipientLabel, ibanLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = Constants.verticalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    var viewModel: InvoiceTableViewCellModel? {
        didSet {
            guard let viewModel = viewModel else { return }

            recipientLabel.text = viewModel.recipientNameText
            recipientLabel.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
            recipientLabel.isHidden = viewModel.isRecipientLabelHidden

            ibanLabel.text = viewModel.ibanText
            ibanLabel.isHidden = viewModel.isDueDataLabelHidden

            amountLabel.text = viewModel.amountToPayText
            amountLabel.textColor = Constants.amountLabelTextColor

            if viewModel.shouldShowPaymentComponent {
                verticalStackView.addArrangedSubview(viewModel.paymentComponentView)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubViews()
    }

    private func setupSubViews() {
        selectionStyle = .none

        recipientLabel.translatesAutoresizingMaskIntoConstraints = false
        ibanLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false

        amountLabel.textAlignment = .right

        contentView.addSubview(horizontalStackView)

        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InvoiceTableViewCell {
    enum Constants {
        static let amountLabelTextColor = UIColor(red: 0.0, green: 158.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
        static let padding = 16.0
        static let horizontalSpacing = 10.0
        static let verticalSpacing = 0.0
    }
}
