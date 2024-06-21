//
//  MockPaymentComponentsController.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//


import UIKit
@testable import GiniMerchantSDK
@testable import GiniHealthAPILibrary

class MockPaymentComponents: PaymentComponentsProtocol {

    var isLoading: Bool = false
    var selectedPaymentProvider: PaymentProvider?
    
    private var giniMerchant: GiniMerchant
    private var paymentProviders: PaymentProviders = []
    private var installedPaymentProviders: PaymentProviders = []
    private let giniMerchantConfiguration = GiniMerchantConfiguration.shared
    
    init(giniMerchant: GiniMerchant) {
        self.giniMerchant = giniMerchant
    }
    
    func loadPaymentProviders() {
        isLoading = false
        guard let paymentProviderResponse: PaymentProviderResponse = load(fromFile: "provider") else {
            return
        }
        if let iconData = Data(url: URL(string: paymentProviderResponse.iconLocation)) {
            selectedPaymentProvider = PaymentProvider(id: paymentProviderResponse.id, name: paymentProviderResponse.name, appSchemeIOS: paymentProviderResponse.appSchemeIOS, minAppVersion: paymentProviderResponse.minAppVersion, colors: paymentProviderResponse.colors, iconData: iconData, appStoreUrlIOS: paymentProviderResponse.appStoreUrlIOS, universalLinkIOS: paymentProviderResponse.universalLinkIOS, index: paymentProviderResponse.index, gpcSupportedPlatforms: paymentProviderResponse.gpcSupportedPlatforms, openWithSupportedPlatforms: paymentProviderResponse.openWithSupportedPlatforms)
        }
    }
    
    func checkIfDocumentIsPayable(docId: String, completion: @escaping (Result<Bool, GiniMerchantError>) -> Void) {
        switch docId {
        case MockSessionManager.payableDocumentID:
            completion(.success(true))
        case MockSessionManager.notPayableDocumentID:
            completion(.success(false))
        case MockSessionManager.missingDocumentID:
            completion(.failure(.apiError(.noResponse)))
        default:
            fatalError("Document id not handled in tests")
        }
    }
    
    func paymentView(documentId: String) -> UIView {
        let viewModel = PaymentComponentViewModel(paymentProvider: selectedPaymentProvider, giniMerchantConfiguration: giniMerchantConfiguration)
        viewModel.documentId = documentId
        let view = PaymentComponentView()
        view.viewModel = viewModel
        return view
    }
    
    func bankSelectionBottomSheet() -> UIViewController {
        let paymentProvidersBottomViewModel = BanksBottomViewModel(paymentProviders: paymentProviders,
                                                                   selectedPaymentProvider: selectedPaymentProvider)
        let paymentProvidersBottomView = BanksBottomView(viewModel: paymentProvidersBottomViewModel)
        return paymentProvidersBottomView
    }
    
    func loadPaymentReviewScreenFor(documentID: String, trackingDelegate: (any GiniMerchantTrackingDelegate)?, completion: @escaping (UIViewController?, GiniMerchantError?) -> Void) {
        switch documentID {
        case MockSessionManager.payableDocumentID:
            completion(PaymentReviewViewController(), nil)
        case MockSessionManager.missingDocumentID:
            completion(nil, .apiError(.noResponse))
        default:
            fatalError("Document id not handled in tests")
        }
    }
    
    func paymentInfoViewController() -> UIViewController {
        let paymentInfoViewController = PaymentInfoViewController()
        let paymentInfoViewModel = PaymentInfoViewModel(paymentProviders: paymentProviders)
        paymentInfoViewController.viewModel = paymentInfoViewModel
        return paymentInfoViewController
    }
}
