//
//  ScreenAPICoordinator.swift
//  GiniHealthSDKExample
//
//  Created by Nadya Karaban on 22.05.23.
//

import GiniBankAPILibrary
import GiniCaptureSDK
import GiniHealthSDK
import GiniHealthAPILibrary
import UIKit

protocol ScreenAPICoordinatorDelegate: AnyObject {
    func screenAPI(coordinator: ScreenAPICoordinator, didFinish: ())
    func openInvoicesList()
}

final class ScreenAPICoordinator: NSObject, Coordinator, GiniHealthTrackingDelegate, GiniCaptureResultsDelegate {
    
    weak var delegate: ScreenAPICoordinatorDelegate?
    var childCoordinators: [Coordinator] = []
    var rootViewController: UIViewController {
        return screenAPIViewController
    }
    
    var giniHealth: GiniHealth?
    var screenAPIViewController: UINavigationController!
    
    let client: GiniHealthAPILibrary.Client
    let documentMetadata: GiniHealthAPILibrary.Document.Metadata?
    weak var analysisDelegate: AnalysisDelegate?
    var visionDocuments: [GiniCaptureDocument]?
    var visionConfiguration: GiniConfiguration
    private var captureExtractedResults: [GiniBankAPILibrary.Extraction] = []
    var hardcodedInvoicesController: HardcodedInvoicesController
    
    // {extraction name} : {entity name}
    private let editableSpecificExtractions = ["paymentRecipient" : "companyname", "paymentReference" : "reference", "paymentPurpose" : "text", "iban" : "iban", "bic" : "bic", "amountToPay" : "amount"]
    
    init(configuration: GiniConfiguration,
         importedDocuments documents: [GiniCaptureDocument]?,
         client: GiniHealthAPILibrary.Client,
         documentMetadata: GiniHealthAPILibrary.Document.Metadata?,
         hardcodedInvoicesController: HardcodedInvoicesController) {
        visionConfiguration = configuration
        visionDocuments = documents
        self.client = client
        self.documentMetadata = documentMetadata
        self.hardcodedInvoicesController = hardcodedInvoicesController
        super.init()
    }
    
    func start(healthAPI: GiniHealthAPI) {
        let viewController = GiniCapture.viewController(importedDocuments: visionDocuments,
                                                        configuration: visionConfiguration,
                                                        resultsDelegate: self,
                                                        networkingService: HealthNetworkingService(lib: healthAPI))
        screenAPIViewController = RootNavigationController(rootViewController: viewController)
        screenAPIViewController.setNavigationBarHidden(true, animated: false)
        screenAPIViewController.delegate = self
        screenAPIViewController.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func onPaymentReviewScreenEvent(event: GiniHealthSDK.TrackingEvent<GiniHealthSDK.PaymentReviewScreenEventType>) {
    }
    
    // MARK: - GiniCaptureResultsDelegate
    
    func giniCaptureDidCancelAnalysis() {
        screenAPIViewController.dismiss(animated: true)
    }
    
    func giniCaptureDidEnterManually() {
        screenAPIViewController.dismiss(animated: true)
    }
    
    func giniCaptureAnalysisDidFinishWith(result: AnalysisResult) {
        var healthExtractions: [GiniHealthAPILibrary.Extraction] = []
        captureExtractedResults = result.extractions.map { $0.value}
        for extraction in captureExtractedResults {
            healthExtractions.append(GiniHealthAPILibrary.Extraction(box: nil, candidates: extraction.candidates, entity: extraction.entity, value: extraction.value, name: extraction.name))
        }

        if let healthSdk = self.giniHealth, let docId = result.document?.id {
            // this step needed since we've got 2 different Document structures
            healthSdk.fetchDataForReview(documentId: docId) { [weak self] resultReview in
                switch resultReview {
                case .success(let data):
                    // Store invoice/document into Invoices list
                    self?.giniHealth?.checkIfDocumentIsPayable(docId: result.document?.id ?? "", completion: { [weak self] resultPayable in
                        switch resultPayable {
                        case .success(let isPayable):
                            let invoice = DocumentWithExtractions(documentID: result.document?.id ?? "",
                                                                  extractions: data.extractions,
                                                                  isPayable: isPayable)
                            self?.hardcodedInvoicesController.appendInvoiceWithExtractions(invoice: invoice)
                            self?.screenAPIViewController.dismiss(animated: true, completion: {
                                self?.delegate?.openInvoicesList()
                            })
                        case .failure(let error):
                            print("❌ Checking if document is payable failed: \(String(describing: error))")
                        }
                    })
                case .failure(let error):
                    print("❌ Document data fetching failed: \(String(describing: error))")
                }
            }
        }
    }
}
// MARK: - UINavigationControllerDelegate

extension ScreenAPICoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is PaymentReviewViewController {
            delegate?.screenAPI(coordinator: self, didFinish: ())
        }
        return nil
    }
}
