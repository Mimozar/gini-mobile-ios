//
//  GiniPayBankNetworkingScreenApiCoordinator.swift
// GiniBank
//
//  Created by Nadya Karaban on 03.03.21.
//

import Foundation
import UIKit
import GiniCaptureSDK
import GiniBankAPILibrary

protocol Coordinator: AnyObject {
    var rootViewController: UIViewController { get }
    var childCoordinators: [Coordinator] { get set }
}

open class GiniBankNetworkingScreenApiCoordinator: GiniScreenAPICoordinator, GiniCaptureDelegate {
    var childCoordinators: [Coordinator] = []

    // MARK: - GiniCaptureDelegate

    public func didCapture(document: GiniCaptureDocument, networkDelegate: GiniCaptureNetworkDelegate) {
        // The EPS QR codes are a special case, since they don0t have to be analyzed by the Gini Bank API and therefore,
        // they are ready to be delivered after capturing them.
        if let qrCodeDocument = document as? GiniQRCodeDocument,
           let format = qrCodeDocument.qrCodeFormat,
           case .eps4mobile = format {
            let extractions = qrCodeDocument.extractedParameters.compactMap {
                Extraction(box: nil, candidates: nil,
                           entity: QRCodesExtractor.epsCodeUrlKey,
                           value: $0.value,
                           name: QRCodesExtractor.epsCodeUrlKey)
            }
            let extractionResult = ExtractionResult(extractions: extractions,
                                                    lineItems: [],
                                                    returnReasons: [],
                                                    candidates: [:])

            deliver(result: extractionResult, analysisDelegate: networkDelegate)
            return
        }

        // When an non reviewable document or an image in multipage mode is captured,
        // it has to be uploaded right away.
        if giniConfiguration.multipageEnabled || !document.isReviewable {
            if (document as? GiniImageDocument)?.isFromOtherApp ?? false {
                uploadAndStartAnalysisWithReturnAssistant(document: document,
                                                          networkDelegate: networkDelegate,
                                                          uploadDidFail: {
                    self.didCapture(document: document, networkDelegate: networkDelegate)
                })
                return
            }
            if !document.isReviewable {
                uploadAndStartAnalysisWithReturnAssistant(document: document,
                                                          networkDelegate: networkDelegate,
                                                          uploadDidFail: {
                    self.didCapture(document: document, networkDelegate: networkDelegate)
                })
            } else if giniConfiguration.multipageEnabled {
                // When multipage is enabled the document upload result should be communicated to the network delegate
                uploadWithReturnAssistant(document: document,
                                          didComplete: networkDelegate.uploadDidComplete,
                                          didFail: networkDelegate.uploadDidFail)
            }
        }
    }

    public func didReview(documents: [GiniCaptureDocument], networkDelegate: GiniCaptureNetworkDelegate) {
        // It is necessary to check the order when using multipage before
        // creating the composite document
        if giniConfiguration.multipageEnabled {
            documentService.sortDocuments(withSameOrderAs: documents)
        }

        // And review the changes for each document recursively.
        for document in (documents.compactMap { $0 as? GiniImageDocument }) {
            documentService.update(imageDocument: document)
        }

        // In multipage mode the analysis can be triggered once the documents have been uploaded.
        // However, in single mode, the analysis can be triggered right after capturing the image.
        // That is why the document upload shuld be done here and start the analysis afterwards
        if giniConfiguration.multipageEnabled {
            startAnalysisWithReturnAssistant(networkDelegate: networkDelegate)
        } else {
            uploadAndStartAnalysisWithReturnAssistant(document: documents[0],
                                                      networkDelegate: networkDelegate,
                                                      uploadDidFail: {
                self.didReview(documents: documents, networkDelegate: networkDelegate)
            })
        }
    }

    public func didCancelCapturing() {
        resultsDelegate?.giniCaptureDidCancelAnalysis()
    }

    public func didCancelReview(for document: GiniCaptureDocument) {
        documentService.remove(document: document)
    }

    public func didCancelAnalysis() {
        // Cancel analysis process to avoid unnecessary network calls.
        if pages.type == .image {
            documentService.cancelAnalysis()
        } else {
            documentService.resetToInitialState()
        }
    }

    weak var resultsDelegate: GiniCaptureResultsDelegate?
    let documentService: DocumentServiceProtocol
    var giniBankConfiguration = GiniBankConfiguration.shared

    public init(client: Client,
                resultsDelegate: GiniCaptureResultsDelegate,
                configuration: GiniBankConfiguration,
                documentMetadata: Document.Metadata?,
                api: APIDomain,
                trackingDelegate: GiniCaptureTrackingDelegate?,
                lib: GiniBankAPI) {
        documentService = GiniBankNetworkingScreenApiCoordinator.documentService(with: lib,
                                                                                 documentMetadata: documentMetadata,
                                                                                 configuration: configuration,
                                                                                 for: api)
        let captureConfiguration = configuration.captureConfiguration()
        super.init(withDelegate: nil, giniConfiguration: captureConfiguration)

        visionDelegate = self
        GiniBank.setConfiguration(configuration)
        giniBankConfiguration = configuration
        giniBankConfiguration.documentService = documentService
        self.resultsDelegate = resultsDelegate
        self.trackingDelegate = trackingDelegate
    }

    public init(resultsDelegate: GiniCaptureResultsDelegate,
                configuration: GiniBankConfiguration,
                documentMetadata: Document.Metadata?,
                trackingDelegate: GiniCaptureTrackingDelegate?,
                captureNetworkService: GiniCaptureNetworkService) {

        documentService = DocumentService(giniCaptureNetworkService: captureNetworkService,
                                          metadata: documentMetadata)
        let captureConfiguration = configuration.captureConfiguration()

        super.init(withDelegate: nil,
                   giniConfiguration: captureConfiguration)
        giniBankConfiguration = configuration
        giniBankConfiguration.documentService = documentService
        GiniBank.setConfiguration(configuration)

        visionDelegate = self
        self.resultsDelegate = resultsDelegate
        self.trackingDelegate = trackingDelegate
    }

    convenience init(client: Client,
                     resultsDelegate: GiniCaptureResultsDelegate,
                     configuration: GiniBankConfiguration,
                     documentMetadata: Document.Metadata?,
                     api: APIDomain,
                     userApi: UserDomain,
                     trackingDelegate: GiniCaptureTrackingDelegate?) {
        let lib = GiniBankAPI
            .Builder(client: client, api: api, userApi: userApi)
            .build()

        self.init(client: client,
                  resultsDelegate: resultsDelegate,
                  configuration: configuration,
                  documentMetadata: documentMetadata,
                  api: api,
                  trackingDelegate: trackingDelegate,
                  lib: lib)
    }

    private static func documentService(with lib: GiniBankAPI,
                                        documentMetadata: Document.Metadata?,
                                        configuration: GiniBankConfiguration,
                                        for api: APIDomain) -> DocumentServiceProtocol {
        switch api {
        case .default, .gym, .custom:
            return DocumentService(lib: lib, metadata: documentMetadata)
        }
    }

    private func deliver(result: ExtractionResult, analysisDelegate: AnalysisDelegate) {
        let hasExtractions = result.extractions.count > 0

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if hasExtractions {
                let images = self.pages.compactMap { $0.document.previewImage }
                let extractions: [String: Extraction] = Dictionary(uniqueKeysWithValues: result.extractions.compactMap {
                    guard let name = $0.name else { return nil }

                    return (name, $0)
                })

                let result = AnalysisResult(extractions: extractions,
                                            lineItems: result.lineItems,
                                            images: images,
                                            candidates: result.candidates)

                let documentService = self.documentService

                self.resultsDelegate?.giniCaptureAnalysisDidFinishWith(result: result)
                documentService.resetToInitialState()
            } else {
                analysisDelegate.tryDisplayNoResultsScreen()
                self.documentService.resetToInitialState()
            }
        }
    }

    public func didPressEnterManually() {
        self.resultsDelegate?.giniCaptureDidEnterManually()
    }
}

extension GiniBankNetworkingScreenApiCoordinator {
    // MARK: - Deliver with Skonto
    public func deliverWithSkonto(result: ExtractionResult, analysisDelegate: AnalysisDelegate? = nil) {
        let hasExtractions = result.extractions.count > 0

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if hasExtractions {
                let images = self.pages.compactMap { $0.document.previewImage }
                let extractions: [String: Extraction] = Dictionary(uniqueKeysWithValues: result.extractions.compactMap {
                    guard let name = $0.name else { return nil }

                    return (name, $0)
                })

                let documentService = self.documentService

                let result = AnalysisResult(extractions: extractions,
                                            skontoDiscounts: result.skontoDiscounts,
                                            images: images,
                                            document: documentService.document,
                                            candidates: result.candidates)
                self.resultsDelegate?.giniCaptureAnalysisDidFinishWith(result: result)

                self.giniBankConfiguration.skontoDiscounts = result.skontoDiscounts
            } else {
                analysisDelegate?.tryDisplayNoResultsScreen()
                self.documentService.resetToInitialState()
            }
        }
    }

    public func showSkontoScreen(skontoDiscounts: SkontoDiscounts) {
        let coordinator = SkontoCoordinator(screenAPINavigationController,
                                            skontoDiscounts)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    private func handleSkontoScreenDisplay(_ extractionResult: ExtractionResult,
                                           _ networkDelegate: GiniCaptureNetworkDelegate) {
        do {
            let skontoDiscounts = try SkontoDiscounts(extractions: extractionResult)
            showSkontoScreen(skontoDiscounts: skontoDiscounts)
        } catch {
            deliverWithSkonto(result: extractionResult,
                              analysisDelegate: networkDelegate)
        }
    }

    // MARK: Deliver with Return Assistant
    public func deliverWithReturnAssistant(result: ExtractionResult, analysisDelegate: AnalysisDelegate) {
        let hasExtractions = result.extractions.count > 0

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if hasExtractions {
                let images = self.pages.compactMap { $0.document.previewImage }
                let extractions: [String: Extraction] = Dictionary(uniqueKeysWithValues: result.extractions.compactMap {
                    guard let name = $0.name else { return nil }

                    return (name, $0)
                })

                let documentService = self.documentService

                let result = AnalysisResult(extractions: extractions,
                                            lineItems: result.lineItems,
                                            images: images,
                                            document: documentService.document,
                                            candidates: result.candidates)
                self.resultsDelegate?.giniCaptureAnalysisDidFinishWith(result: result)

                self.giniBankConfiguration.lineItems = result.lineItems
            } else {
                analysisDelegate.tryDisplayNoResultsScreen()
                self.documentService.resetToInitialState()
            }
        }
    }

    public func showDigitalInvoiceScreen(digitalInvoice: DigitalInvoice, analysisDelegate: AnalysisDelegate) {
        let coordinator = DigitalInvoiceCoordinator(navigationController: screenAPINavigationController,
                                                    digitalInvoice: digitalInvoice,
                                                    analysisDelegate: analysisDelegate)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    // MARK: - Start Analysis with Return Assistant or Skonto

    public func startAnalysisWithReturnAssistant(networkDelegate: GiniCaptureNetworkDelegate) {
        documentService.startAnalysis { result in

            switch result {
            case let .success(extractionResult):

                DispatchQueue.main.async {

                    if GiniBankConfiguration.shared.returnAssistantEnabled && extractionResult.lineItems != nil {
                        self.handleReturnAssistantScreenDisplay(extractionResult, networkDelegate)
                    } else if GiniBankConfiguration.shared.skontoEnabled && extractionResult.skontoDiscounts != nil {
                        self.handleSkontoScreenDisplay(extractionResult, networkDelegate)
                    } else {
                        self.deliverWithReturnAssistant(result: extractionResult, analysisDelegate: networkDelegate)
                    }
                }

            case let .failure(error):
                guard error != .requestCancelled else {
                    return
                }

                DispatchQueue.main.async { [weak self] in
                    guard error != .requestCancelled else { return }
                    self?.displayError(errorType: ErrorType(error: error), animated: true)

                }
            }
        }
    }

    private func handleReturnAssistantScreenDisplay(_ extractionResult: ExtractionResult,
                                                    _ networkDelegate: GiniCaptureNetworkDelegate) {
        do {
            let digitalInvoice = try DigitalInvoice(extractionResult: extractionResult)
            showDigitalInvoiceScreen(digitalInvoice: digitalInvoice,
                                     analysisDelegate: networkDelegate)
        } catch {
            deliverWithReturnAssistant(result: extractionResult,
                                       analysisDelegate: networkDelegate)
        }
    }

    func uploadWithReturnAssistant(document: GiniCaptureDocument,
                                   didComplete: @escaping (GiniCaptureDocument) -> Void,
                                   didFail: @escaping (GiniCaptureDocument, GiniError) -> Void) {
        documentService.upload(document: document) { result in
            switch result {
            case .success:
                didComplete(document)
            case let .failure(error):
                didFail(document, error)
            }
        }
    }

    func uploadAndStartAnalysisWithReturnAssistant(document: GiniCaptureDocument,
                                                   networkDelegate: GiniCaptureNetworkDelegate,
                                                   uploadDidFail: @escaping () -> Void) {
        uploadWithReturnAssistant(document: document, didComplete: { _ in
            self.startAnalysisWithReturnAssistant(networkDelegate: networkDelegate)
        }, didFail: { _, error in
            DispatchQueue.main.async {
                guard error != .requestCancelled else { return }
                networkDelegate.displayError(errorType: ErrorType(error: error), animated: true)
            }
        })
    }
}

extension GiniBankNetworkingScreenApiCoordinator: DigitalInvoiceCoordinatorDelegate {
    func didFinishAnalysis(_ coordinator: DigitalInvoiceCoordinator,
                           invoice: DigitalInvoice?,
                           analysisDelegate: GiniCaptureSDK.AnalysisDelegate) {
        guard let invoice = invoice else { return }
        deliverWithReturnAssistant(result: invoice.extractionResult, analysisDelegate: analysisDelegate)
    }

    func didCancelAnalysis(_ coordinator: DigitalInvoiceCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        resultsDelegate?.giniCaptureDidCancelAnalysis()
    }
}

extension GiniBankNetworkingScreenApiCoordinator: SkontoCoordinatorDelegate {
    func didFinishAnalysis(_ coordinator: SkontoCoordinator,
                           _ editedExtractionResult: GiniBankAPILibrary.ExtractionResult?) {
        guard let editedExtractionResult else { return }
        deliverWithSkonto(result: editedExtractionResult)
    }

    func didCancelAnalysis(_ coordinator: SkontoCoordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
        pages = []
        didCancelAnalysis()
        _ = start(withDocuments: nil, animated: true)
    }
}
