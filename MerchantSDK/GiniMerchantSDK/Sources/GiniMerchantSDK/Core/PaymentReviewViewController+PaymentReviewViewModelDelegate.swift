//
//  PaymentReviewViewController+PaymentReviewViewModelDelegate.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//

import UIKit

extension PaymentReviewViewController: PaymentReviewViewModelDelegate {
    func presentInstallAppBottomSheet(bottomSheet: BottomSheetViewController) {
        bottomSheet.minHeight = inputContainer.frame.height
        presentBottomSheet(viewController: bottomSheet)
    }

    func createPaymentRequestAndOpenBankApp() {
        self.presentedViewController?.dismiss(animated: true)
        if paymentInfoContainerView.noErrorsFound() {
            createPaymentRequest()
        }
    }

    func presentShareInvoiceBottomSheet(bottomSheet: BottomSheetViewController) {
        bottomSheet.minHeight = inputContainer.frame.height
        presentBottomSheet(viewController: bottomSheet)
    }

    func obtainPDFFromPaymentRequest() {
        model?.paymentComponentsController.obtainPDFURLFromPaymentRequest(paymentInfo: paymentInfoContainerView.obtainPaymentInfo(), viewController: self)
    }
}
