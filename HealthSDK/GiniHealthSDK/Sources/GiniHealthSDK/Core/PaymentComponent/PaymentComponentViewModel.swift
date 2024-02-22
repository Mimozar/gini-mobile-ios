//
//  PaymentComponentViewModel.swift
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

     - parameter documentID: Id of document
     */
    func didTapOnMoreInformation(documentID: String?)

    /**
     Called when the user tapped on payment provider picker to change the selected payment provider or install it

     - parameter documentID: Id of document
     */
    func didTapOnBankPicker(documentID: String?)

    /**
     Called when the user tapped on the pay the invoice button to pay the invoice/document
     - parameter documentID: Id of document
     */
    func didTapOnPayInvoice(documentID: String?)
}

/**
 Helping extension for using the PaymentComponentViewProtocol methods without the document ID. This should be kept by the document view model and passed hierarchically from there.

 */
extension PaymentComponentViewProtocol {
    public func didTapOnMoreInformation() {
        didTapOnMoreInformation(documentID: nil)
    }
    public func didTapOnBankPicker() {
        didTapOnBankPicker(documentID: nil)
    }
    public func didTapOnPayInvoice() {
        didTapOnPayInvoice(documentID: nil)
    }
}

final class PaymentComponentViewModel {
    private var giniHealth: GiniHealth
    var giniHealthConfiguration = GiniHealthConfiguration.shared

    let backgroundColor: UIColor = UIColor.from(giniColor: GiniColor(lightModeColor: .clear, 
                                                                     darkModeColor: .clear))

    // More information part
    let moreInformationAccentColor: UIColor = GiniColor(lightModeColor: UIColor.GiniColors.dark2, 
                                                        darkModeColor: UIColor.GiniColors.light4).uiColor()
    let moreInformationLabelText = NSLocalizedStringPreferredFormat("ginihealth.paymentcomponent.moreInformation.label", comment: "")
    let moreInformationActionablePartText = NSLocalizedStringPreferredFormat("ginihealth.paymentcomponent.moreInformation.underlined.part", comment: "")
    var moreInformationLabelFont: UIFont
    var moreInformationLabelLinkFont: UIFont
    let moreInformationIconName = "info.circle"
    
    // Select bank label
    let selectYourBankLabelText = NSLocalizedStringPreferredFormat("ginihealth.paymentcomponent.selectYourBank.label", comment: "")
    let selectYourBankLabelFont: UIFont
    let selectYourBankAccentColor: UIColor = GiniColor(lightModeColor: UIColor.GiniColors.dark1,
                                                       darkModeColor: UIColor.GiniColors.light1).uiColor()
    
    // Bank image icon
    private var bankImageIconData: Data?
    var bankImageIcon: UIImage {
        if let bankImageIconData {
            return UIImage(data: bankImageIconData) ?? UIImage()
        }
        return UIImage()
    }

    // Bank name label
    private var bankName: String?
    var bankNameLabelText: String {
        if let bankName, !bankName.isEmpty {
            return isPaymentProviderInstalled ? bankName : placeholderBankNameText
        }
        return placeholderBankNameText
    }
    private let placeholderBankNameText: String = NSLocalizedStringPreferredFormat("ginihealth.paymentcomponent.selectBank.label", comment: "")
    
    let chevronDownIconName: String = "iconChevronDown"
    let chevronDownIconColor: UIColor = GiniColor(lightModeColor: UIColor.GiniColors.light7,
                                                  darkModeColor: UIColor.GiniColors.light1).uiColor()
    
    // Payment provider colors
    var paymentProviderColors: ProviderColors?

    // Pay invoice label
    let payInvoiceLabelText: String = NSLocalizedStringPreferredFormat("ginihealth.paymentcomponent.payInvoice.label", comment: "")

    // Payment provider installation status
    var isPaymentProviderInstalled: Bool {
        if let paymentProviderScheme, let url = URL(string: paymentProviderScheme), UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }
    private var paymentProviderScheme: String?

    weak var delegate: PaymentComponentViewProtocol?
    
    init(paymentProvider: PaymentProvider?, giniHealth: GiniHealth) {
        self.giniHealth = giniHealth

        let defaultRegularFont: UIFont = giniHealthConfiguration.customFont.regular
        let defaultBoldFont: UIFont = giniHealthConfiguration.customFont.regular
        let defaultMediumFont: UIFont = giniHealthConfiguration.customFont.medium
        self.moreInformationLabelFont = giniHealthConfiguration.textStyleFonts[.caption1] ?? defaultRegularFont
        self.moreInformationLabelLinkFont = giniHealthConfiguration.textStyleFonts[.linkBold] ?? defaultBoldFont
        self.selectYourBankLabelFont = giniHealthConfiguration.textStyleFonts[.subtitle2] ?? defaultMediumFont
        
        self.bankImageIconData = paymentProvider?.iconData
        self.bankName = paymentProvider?.name
        self.paymentProviderColors = paymentProvider?.colors
        self.paymentProviderScheme = paymentProvider?.appSchemeIOS
    }
    
    func tapOnMoreInformation() {
        delegate?.didTapOnMoreInformation()
    }
    
    func tapOnBankPicker() {
        delegate?.didTapOnBankPicker()
    }
    
    func tapOnPayInvoiceView() {
        delegate?.didTapOnPayInvoice()
    }
}
