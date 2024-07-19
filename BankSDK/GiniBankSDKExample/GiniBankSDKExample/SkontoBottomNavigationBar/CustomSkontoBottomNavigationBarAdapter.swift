//
//  CustomSkontoBottomNavigationBarAdapter.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//

import UIKit
import GiniBankSDK

final class CustomSkontoNavigationBarBottomAdapter: SkontoNavigationBarBottomAdapter {

    private var proceedButtonCallback: (() -> Void)?
    // MARK: Temporary remove help action
//    private var helpButtonCallback: (() -> Void)?
    private var backButtonCallback: (() -> Void)?
    private var view: CustomSkontoBottomNavigationBar?

    func setProceedButtonClickedActionCallback(_ callback: @escaping () -> Void) {
        proceedButtonCallback = callback
    }

    // MARK: Temporary remove help action
//    func setHelpButtonClickedActionCallback(_ callback: @escaping  () -> Void) {
//        helpButtonCallback = callback
//    }

    func setBackButtonClickedActionCallback(_ callback: @escaping () -> Void) {
        backButtonCallback = callback
    }

    func updateTotalPrice(priceWithCurrencyCode price: String?) {
        view?.updatePrice(with: price)
    }

    func updateDiscountValue(with discount: String?) {
        view?.updateDiscountValue(with: discount)
    }

    func updateDiscountBadge(enabled: Bool) {
        view?.updateDiscountBadge(enabled: enabled)
    }

    func updateSavedAmount(with text: String?) {
        view?.updateSavedAmount(with: text)
    }

    func updateSavedAmount(enabled: Bool) {
        view?.updateSavedAmount(enabled: enabled)
    }

    func injectedView() -> UIView {
        let navigationBar = CustomSkontoBottomNavigationBar(proceedAction: proceedButtonCallback,
                                                             backAction: backButtonCallback)
        view = navigationBar
        return navigationBar
    }

    func onDeinit() {
        proceedButtonCallback = nil
    }
}
