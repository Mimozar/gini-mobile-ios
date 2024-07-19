//
//  PaymentComponentViewModel.swift
//  GiniMerchantSDK
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//


import UIKit
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
    let giniMerchantConfiguration: GiniMerchantConfiguration

    let backgroundColor: UIColor = UIColor.from(giniColor: GiniColor(lightModeColor: .clear, 
                                                                     darkModeColor: .clear))

    // More information part
    let moreInformationAccentColor: UIColor = GiniColor.standard2.uiColor()
    let moreInformationLabelTextColor: UIColor = GiniColor.standard4.uiColor()
    let moreInformationLabelText = NSLocalizedStringPreferredFormat("gini.merchant.paymentcomponent.moreInformation.label",
                                                                    comment: "Text for more information label")
    let moreInformationActionablePartText = NSLocalizedStringPreferredFormat("gini.merchant.paymentcomponent.moreInformation.underlined.part",
                                                                             comment: "Text for more information actionable part from the label")
    var moreInformationLabelFont: UIFont
    var moreInformationLabelLinkFont: UIFont
    
    // Select bank label
    let selectYourBankLabelText = NSLocalizedStringPreferredFormat("gini.merchant.paymentcomponent.selectYourBank.label", 
                                                                   comment: "Text for the select your bank label that's above the payment provider picker")
    let selectYourBankLabelFont: UIFont
    let selectYourBankAccentColor: UIColor = GiniColor.standard1.uiColor()
    
    // Bank image icon
    private var bankImageIconData: Data?
    var bankImageIcon: UIImage? {
        guard let bankImageIconData else { return nil }
        return UIImage(data: bankImageIconData)
    }

    // Primary button
    let notInstalledBankTextColor: UIColor = GiniColor.standard4.uiColor()
    let placeholderBankNameText: String = NSLocalizedStringPreferredFormat("gini.merchant.paymentcomponent.selectBank.label",
                                                                                   comment: "Placeholder text used when there isn't a payment provider app installed")
    
    let chevronDownIcon: UIImage = GiniMerchantImage.chevronDown.preferredUIImage()
    let chevronDownIconColor: UIColor = GiniColor(lightModeColorName: .light7, darkModeColorName: .light1).uiColor()
    
    // Payment provider colors
    var paymentProviderColors: ProviderColors?

    // Pay invoice label
    let payInvoiceLabelText: String = NSLocalizedStringPreferredFormat("gini.merchant.paymentcomponent.payInvoice.label", 
                                                                       comment: "Title label used for the pay invoice button")

    private var paymentProviderScheme: String?

    weak var delegate: PaymentComponentViewProtocol?
    
    var documentId: String?
    
    var minimumButtonsHeight: CGFloat
    
    var hasBankSelected: Bool
    
    init(paymentProvider: PaymentProvider?, giniMerchantConfiguration: GiniMerchantConfiguration) {
        self.giniMerchantConfiguration = giniMerchantConfiguration

        self.moreInformationLabelFont = giniMerchantConfiguration.font(for: .captions1)
        self.moreInformationLabelLinkFont = giniMerchantConfiguration.font(for: .linkBold)
        self.selectYourBankLabelFont = giniMerchantConfiguration.font(for: .subtitle2)

        self.hasBankSelected = paymentProvider != nil
        self.bankImageIconData = paymentProvider?.iconData
        self.paymentProviderColors = paymentProvider?.colors
        self.paymentProviderScheme = paymentProvider?.appSchemeIOS
        
        self.minimumButtonsHeight = giniMerchantConfiguration.paymentComponentButtonsHeight
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
