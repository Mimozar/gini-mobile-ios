//
//  InstallAppBottomViewModel.swift
//  GiniMerchantSDK
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//


import UIKit
import GiniUtilites
import GiniPaymentComponents
import GiniHealthAPILibrary

protocol InstallAppBottomViewProtocol: AnyObject {
    func didTapOnContinue()
}

final class InstallAppBottomViewModel {
    let primaryButtonConfiguration: ButtonConfiguration
    let configuration: InstallAppConfiguration
    let strings: InstallAppStrings
    let poweredByGiniViewModel: PoweredByGiniViewModel

    var selectedPaymentProvider: PaymentProvider?
    var paymentProviderColors: ProviderColors?
    
    weak var viewDelegate: InstallAppBottomViewProtocol?

    private var bankImageIconData: Data?
    var bankImageIcon: UIImage {
        if let bankImageIconData {
            return UIImage(data: bankImageIconData) ?? UIImage()
        }
        return UIImage()
    }

    var moreInformationLabelText: String {
        isBankInstalled ?
        strings.moreInformationTipPattern.replacingOccurrences(of: bankToReplaceString, with: selectedPaymentProvider?.name ?? "") :
        strings.moreInformationNotePattern.replacingOccurrences(of: bankToReplaceString, with: selectedPaymentProvider?.name ?? "")
    }

    let titleText: String
    let bankToReplaceString = "[BANK]"
    
    var isBankInstalled: Bool {
        selectedPaymentProvider?.appSchemeIOS.canOpenURLString() == true
    }

    init(selectedPaymentProvider: PaymentProvider?,
         installAppConfiguration: InstallAppConfiguration,
         strings: InstallAppStrings,
         primaryButtonConfiguration: ButtonConfiguration,
         poweredByGiniConfiguration: PoweredByGiniConfiguration,
         poweredByGiniStrings: PoweredByGiniStrings) {
        self.selectedPaymentProvider = selectedPaymentProvider
        self.bankImageIconData = selectedPaymentProvider?.iconData
        self.paymentProviderColors = selectedPaymentProvider?.colors
        self.configuration = installAppConfiguration
        self.strings = strings
        self.primaryButtonConfiguration = primaryButtonConfiguration
        self.poweredByGiniViewModel = PoweredByGiniViewModel(configuration: poweredByGiniConfiguration, strings: poweredByGiniStrings)
        
        titleText = strings.titlePattern.replacingOccurrences(of: bankToReplaceString, with: selectedPaymentProvider?.name ?? "")
    }
    
    func didTapOnContinue() {
        viewDelegate?.didTapOnContinue()
    }
}
