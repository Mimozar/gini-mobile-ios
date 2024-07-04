//
//  SkontoAmountView.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//

import UIKit

protocol SkontoAmountViewDelegate: AnyObject {
    func textFieldPriceChanged(editedText: String)
}

class SkontoAmountView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleLabelText
        label.font = configuration.textStyleFonts[.footnote]
        label.textColor = .giniColorScheme().text.secondary.uiColor()
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.text = textFieldInitialText
        textField.textColor = .giniColorScheme().text.primary.uiColor()
        textField.font = configuration.textStyleFonts[.body]
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.isUserInteractionEnabled = isEditable
        textField.adjustsFontForContentSizeCategory = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.text = currencyLabelText
        label.textColor = .giniColorScheme().text.secondary.uiColor()
        label.font = configuration.textStyleFonts[.body]
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.giniColorScheme().bg.border.uiColor().cgColor
        view.layer.borderWidth = isEditable ? 1 : 0
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(title: String,
         price: Price,
         isEditable: Bool = true) {
        self.titleLabelText = title
        self.textFieldInitialText = price.stringWithoutSymbol ?? ""
        self.currencyLabelText = price.currencySymbol ?? ""
        self.isEditable = isEditable
        super.init(frame: .zero)
        setupView()
    }

    private let titleLabelText: String
    private let textFieldInitialText: String
    private let currencyLabelText: String
    private var isEditable: Bool
    private let configuration = GiniBankConfiguration.shared
    weak var delegate: SkontoAmountViewDelegate?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .giniColorScheme().bg.inputUnfocused.uiColor()
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(textField)
        containerView.addSubview(currencyLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        currencyLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        currencyLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),

            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.padding),

            currencyLabel.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            currencyLabel.leadingAnchor.constraint(equalTo: textField.trailingAnchor,
                                                   constant: Constants.currencyLabelHorizontalPadding),
            currencyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding)
        ])
    }

    func configure(isEditable: Bool, price: Price) {
        textField.text = price.stringWithoutSymbol ?? ""
        self.isEditable = isEditable
        containerView.layer.borderWidth = isEditable ? 1 : 0
        textField.isUserInteractionEnabled = isEditable
        currencyLabel.isHidden = isEditable ? false : true
    }
}

extension SkontoAmountView: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        guard let text = textField.text, let textRange = Range(range, in: text) else {
            return true
        }

        let updatedText = text.replacingCharacters(in: textRange, with: string)
        let sanitizedText = sanitizeInput(updatedText)

        guard let decimal = Decimal(string: sanitizedText) else {
            return false
        }

        let formattedText = formatDecimal(decimal)
        updateTextField(textField, with: formattedText, originalText: text)

        return false
    }

    private func sanitizeInput(_ text: String) -> String {
        return String(text.trimmingCharacters(in: .whitespaces).filter { $0.isNumber }.prefix(6))
    }

    private func formatDecimal(_ decimal: Decimal) -> String? {
        let decimalWithFraction = decimal / 100
        return Price.stringWithoutSymbol(from: decimalWithFraction)?.trimmingCharacters(in: .whitespaces)
    }

    private func updateTextField(_ textField: UITextField, with newText: String?, originalText: String) {
        guard let newText = newText else { return }
        let selectedRange = textField.selectedTextRange
        textField.text = newText
        self.delegate?.textFieldPriceChanged(editedText: textField.text ?? "")
        adjustCursorPosition(textField, newText: newText, originalText: originalText, selectedRange: selectedRange)
    }

    private func adjustCursorPosition(_ textField: UITextField,
                                      newText: String,
                                      originalText: String,
                                      selectedRange: UITextRange?) {
        guard let selectedRange = selectedRange else { return }
        let countDelta = newText.count - originalText.count
        let offset = countDelta == 0 ? 1 : countDelta
        textField.moveSelectedTextRange(from: selectedRange.start, to: offset)
    }
}

private extension SkontoAmountView {
    enum Constants {
        static let padding: CGFloat = 12
        static let currencyLabelHorizontalPadding: CGFloat = 10
    }
}
