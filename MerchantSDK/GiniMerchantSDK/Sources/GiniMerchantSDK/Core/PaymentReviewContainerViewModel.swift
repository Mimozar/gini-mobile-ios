//
//  PaymentReviewContainerViewModel.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//


import Foundation

class PaymentReviewContainerViewModel {
    var onExtractionFetched: (() -> Void)?
    var selectedPaymentProvider: PaymentProvider

    // Pay invoice label
    let payInvoiceLabelText: String = NSLocalizedStringPreferredFormat("gini.merchant.reviewscreen.banking.app.button.label",
                                                                       comment: "Title label used for the pay invoice button")

    public var extractions: [Extraction] {
        didSet {
            self.onExtractionFetched?()
        }
    }

    init(extractions: [Extraction], selectedPaymentProvider: PaymentProvider) {
        self.extractions = extractions
        self.selectedPaymentProvider = selectedPaymentProvider
    }
}
