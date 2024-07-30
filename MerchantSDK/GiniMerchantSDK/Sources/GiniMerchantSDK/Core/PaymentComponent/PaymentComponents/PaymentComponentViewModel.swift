//
//  PaymentComponentViewModel.swift
//  GiniMerchantSDK
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//


import UIKit
import GiniPaymentComponents
import GiniHealthAPILibrary

/**
 Delegate to inform about the actions happened of the custom payment component view.
 You may find out when the user tapped on more information area, on the payment provider picker or on the pay invoice button

 */
public protocol PaymentComponentViewProtocol: AnyObject {
    /**
     Called when the user tapped on the more information actionable label or the information icon

     - parameter documentId: Id of document
     */
    func didTapOnMoreInformation(documentId: String?)

    /**
     Called when the user tapped on payment provider picker to change the selected payment provider or install it

     - parameter documentId: Id of document
     */
    func didTapOnBankPicker(documentId: String?)

    /**
     Called when the user tapped on the pay the invoice button to pay the invoice/document
     - parameter documentId: Id of document
     */
    func didTapOnPayInvoice(documentId: String?)
}

/**
 Helping extension for using the PaymentComponentViewProtocol methods without the document ID. This should be kept by the document view model and passed hierarchically from there.

 */
extension PaymentComponentViewProtocol {
    public func didTapOnMoreInformation() {
        didTapOnMoreInformation(documentId: nil)
    }
    public func didTapOnBankPicker() {
        didTapOnBankPicker(documentId: nil)
    }
    public func didTapOnPayInvoice() {
        didTapOnPayInvoice(documentId: nil)
    }
}

final class PaymentComponentViewModel {
    let primaryButtonConfiguration: ButtonConfiguration
    let secondaryButtonConfiguration: ButtonConfiguration
    let configuration: PaymentComponentsConfiguration
    let strings: PaymentComponentsStrings
    let poweredByGiniViewModel: PoweredByGiniViewModel
    let moreInformationViewModel: MoreInformationViewModel
    let paymentProviderColors: ProviderColors?

    // Bank image icon
    private var bankImageIconData: Data?
    var bankImageIcon: UIImage? {
        guard let bankImageIconData else { return nil }
        return UIImage(data: bankImageIconData)
    }

    private var paymentProviderScheme: String?

    weak var delegate: PaymentComponentViewProtocol?
    
    var documentId: String?
    
    var minimumButtonsHeight: CGFloat
    
    var hasBankSelected: Bool
    
    init(paymentProvider: PaymentProvider?,
         primaryButtonConfiguration: ButtonConfiguration,
         secondaryButtonConfiguration: ButtonConfiguration,
         configuration: PaymentComponentsConfiguration,
         strings: PaymentComponentsStrings,
         poweredByGiniConfiguration: PoweredByGiniConfiguration,
         poweredByGiniStrings: PoweredByGiniStrings,
         moreInformationConfiguration: MoreInformationConfiguration,
         moreInformationStrings: MoreInformationStrings,
         minimumButtonsHeight: CGFloat) {
        self.configuration = configuration
        self.strings = strings
        self.primaryButtonConfiguration = primaryButtonConfiguration
        self.secondaryButtonConfiguration = secondaryButtonConfiguration

        self.hasBankSelected = paymentProvider != nil
        self.bankImageIconData = paymentProvider?.iconData
        self.paymentProviderColors = paymentProvider?.colors
        self.paymentProviderScheme = paymentProvider?.appSchemeIOS
        
        self.minimumButtonsHeight = minimumButtonsHeight

        self.poweredByGiniViewModel = PoweredByGiniViewModel(configuration: poweredByGiniConfiguration, strings: poweredByGiniStrings)
        self.moreInformationViewModel = MoreInformationViewModel(configuration: moreInformationConfiguration, strings: moreInformationStrings)
    }
    
    func tapOnMoreInformation() {
        delegate?.didTapOnMoreInformation(documentId: documentId)
    }
    
    func tapOnBankPicker() {
        delegate?.didTapOnBankPicker(documentId: documentId)
    }
    
    func tapOnPayInvoiceView() {
        savePaymentComponentViewUsageStatus()
        delegate?.didTapOnPayInvoice(documentId: documentId)
    }
    
    // Function to check if Payment was used at least once
    func isPaymentComponentUsed() -> Bool {
        return UserDefaults.standard.bool(forKey: Constants.paymentComponentViewUsedKey)
    }
    
    // Function to save the boolean value indicating whether Payment was used
    private func savePaymentComponentViewUsageStatus() {
        UserDefaults.standard.set(true, forKey: Constants.paymentComponentViewUsedKey)
    }
}

extension PaymentComponentViewModel {
    private enum Constants {
        static let paymentComponentViewUsedKey = "kPaymentComponentViewUsed"
    }
}
