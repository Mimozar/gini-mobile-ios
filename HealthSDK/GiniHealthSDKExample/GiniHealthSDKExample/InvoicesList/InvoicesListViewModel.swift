//
//  InvoicesListViewModel.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//


import UIKit
import GiniHealthAPILibrary
import GiniCaptureSDK
import GiniHealthSDK

struct DocumentWithExtractions: Codable {
    var documentID: String
    var amountToPay: String?
    var paymentDueDate: String?
    var recipient: String?
    var isPayable: Bool?

    init(documentID: String, extractionResult: GiniHealthAPILibrary.ExtractionResult) {
        self.documentID = documentID
        self.amountToPay = extractionResult.payment?.first?.first(where: {$0.name == "amount_to_pay"})?.value
        self.paymentDueDate = extractionResult.extractions.first(where: {$0.name == "payment_due_date"})?.value
        self.recipient = extractionResult.payment?.first?.first(where: {$0.name == "payment_recipient"})?.value
    }
    
    init(documentID: String, extractions: [GiniHealthAPILibrary.Extraction], isPayable: Bool) {
        self.documentID = documentID
        self.amountToPay = extractions.first(where: {$0.name == "amount_to_pay"})?.value
        self.paymentDueDate = extractions.first(where: {$0.name == "payment_due_date"})?.value
        self.recipient = extractions.first(where: {$0.name == "payment_recipient"})?.value
        self.isPayable = isPayable
    }
}

final class InvoicesListViewModel {
    
    private let coordinator: InvoicesListCoordinator
    private var documentService: GiniHealthAPILibrary.DefaultDocumentService

    private let hardcodedInvoicesController: HardcodedInvoicesControllerProtocol
    var paymentComponentsController: PaymentComponentsController

    var invoices: [DocumentWithExtractions]

    let noInvoicesText = NSLocalizedString("giniHealthSDKExample.invoicesList.missingInvoices.text", comment: "")
    let titleText = NSLocalizedString("giniHealthSDKExample.invoicesList.title", comment: "")
    let uploadInvoicesText = NSLocalizedString("giniHealthSDKExample.uploadInvoices.button.title", comment: "")
    let cancelText = NSLocalizedString("giniHealthSDKExample.cancel.button.title", comment: "")
    let errorTitleText = NSLocalizedString("giniHealthSDKExample.invoicesList.error", comment: "")

    let backgroundColor: UIColor = GiniColor(light: .white, 
                                             dark: .black).uiColor()
    let tableViewSeparatorColor: UIColor = GiniColor(light: .lightGray, 
                                                     dark: .darkGray).uiColor()
    
    private let tableViewCell: UITableViewCell.Type = InvoiceTableViewCell.self
    private var errors: [String] = []

    let dispatchGroup = DispatchGroup()
    var shouldRefetchExtractions = false
    var documentIDToRefetch: String?

    init(coordinator: InvoicesListCoordinator,
         invoices: [DocumentWithExtractions]? = nil,
         documentService: GiniHealthAPILibrary.DefaultDocumentService,
         hardcodedInvoicesController: HardcodedInvoicesControllerProtocol,
         paymentComponentsController: PaymentComponentsController) {
        self.coordinator = coordinator
        self.hardcodedInvoicesController = hardcodedInvoicesController
        self.invoices = invoices ?? hardcodedInvoicesController.getInvoicesWithExtractions()
        self.documentService = documentService
        self.paymentComponentsController = paymentComponentsController
        self.paymentComponentsController.delegate = self
        self.paymentComponentsController.viewDelegate = self
        self.paymentComponentsController.bottomViewDelegate = self
    }
    
    func viewDidLoad() {
        paymentComponentsController.loadPaymentProviders()
    }
    
    func refetchExtractions() {
        guard shouldRefetchExtractions else { return }
        guard let documentIDToRefetch else { return }
        DispatchQueue.main.async {
            self.coordinator.invoicesListViewController?.showActivityIndicator()
        }
        self.documentService.fetchDocument(with: documentIDToRefetch) { [weak self] result in
            switch result {
            case .success(let document):
                self?.documentService.extractions(for: document, cancellationToken: CancellationToken()) { resultExtractions in
                    switch resultExtractions {
                    case .success(let extractions):
                        self?.shouldRefetchExtractions = false
                        self?.documentIDToRefetch = nil
                        self?.hardcodedInvoicesController.updateDocumentExtractions(documentID: document.id, extractions: extractions)
                        self?.invoices = self?.hardcodedInvoicesController.getInvoicesWithExtractions() ?? []
                        DispatchQueue.main.async {
                            self?.coordinator.invoicesListViewController?.hideActivityIndicator()
                            self?.coordinator.invoicesListViewController?.reloadTableView()
                        }
                    case .failure(let error):
                        self?.errors.append(error.localizedDescription)
                        self?.showErrorsIfAny()
                    }
                }
            case .failure(let error):
                self?.errors.append(error.localizedDescription)
                self?.showErrorsIfAny()
            }
        }
    }

    private func setDispatchGroupNotifier() {
        dispatchGroup.notify(queue: .main) {
            self.showErrorsIfAny()
            if !self.invoices.isEmpty {
                self.hardcodedInvoicesController.storeInvoicesWithExtractions(invoices: self.invoices)
                self.coordinator.invoicesListViewController?.hideActivityIndicator()
                self.coordinator.invoicesListViewController?.reloadTableView()
            }
        }
    }

    private func showErrorsIfAny() {
        if !errors.isEmpty {
            let uniqueErrorMessages = Array(Set(errors))
            DispatchQueue.main.async {
                self.coordinator.invoicesListViewController.showErrorAlertView(error: uniqueErrorMessages.joined(separator: ", "))
            }
            errors = []
        }
    }

    @objc
    func uploadInvoices() {
        coordinator.invoicesListViewController?.showActivityIndicator()
        hardcodedInvoicesController.obtainInvoicePhotosHardcoded { [weak self] invoicesData in
            if !invoicesData.isEmpty {
                self?.uploadDocuments(dataDocuments: invoicesData)
            } else {
                self?.coordinator.invoicesListViewController.hideActivityIndicator()
            }
        }
        setDispatchGroupNotifier()
    }

    private func uploadDocuments(dataDocuments: [Data]) {
        for giniDocument in dataDocuments {
            dispatchGroup.enter()
            self.documentService.createDocument(fileName: nil,
                                                docType: .invoice,
                                                type: .partial(giniDocument),
                                                metadata: nil) { [weak self] result in
                switch result {
                case .success(let createdDocument):
                    Log("Successfully created document with id: \(createdDocument.id)", event: .success)
                    self?.documentService.extractions(for: createdDocument,
                                                      cancellationToken: CancellationToken()) { [weak self] result in
                        switch result {
                        case let .success(extractionResult):
                            Log("Successfully fetched extractions for id: \(createdDocument.id)", event: .success)
                            self?.invoices.append(DocumentWithExtractions(documentID: createdDocument.id,
                                                                          extractionResult: extractionResult))
                            self?.paymentComponentsController.checkIfDocumentIsPayable(docId: createdDocument.id, completion: { [weak self] result in
                                switch result {
                                case let .success(isPayable):
                                    Log("Successfully checked if document \(createdDocument.id) is payable", event: .success)
                                    if let indexDocument = self?.invoices.firstIndex(where: { $0.documentID == createdDocument.id }) {
                                        self?.invoices[indexDocument].isPayable = isPayable
                                    }
                                case let .failure(error):
                                    Log("Checking if document \(createdDocument.id) is payable failed with error: \(String(describing: error))", event: .error)
                                    self?.errors.append(error.localizedDescription)
                                }
                                self?.dispatchGroup.leave()
                            })
                        case let .failure(error):
                            Log("Obtaining extractions from document with id \(createdDocument.id) failed with error: \(String(describing: error))", event: .error)
                            self?.errors.append(error.message)
                            self?.dispatchGroup.leave()
                        }
                    }
                case .failure(let error):
                    Log("Document creation failed: \(String(describing: error))", event: .error)
                    self?.errors.append(error.message)
                    self?.dispatchGroup.leave()
                }
            }
        }
    }
}

extension InvoicesListViewModel: PaymentComponentViewProtocol {

    func didTapOnMoreInformation(documentId: String?) {
        Log("Tapped on More Information", event: .success)
        let paymentInfoViewController = paymentComponentsController.paymentInfoViewController()
        if let presentedViewController = self.coordinator.invoicesListViewController.presentedViewController {
            presentedViewController.dismiss(animated: true) {
                self.coordinator.invoicesListViewController.navigationController?.pushViewController(paymentInfoViewController, animated: true)
            }
        } else {
            self.coordinator.invoicesListViewController.navigationController?.pushViewController(paymentInfoViewController, animated: true)
        }
    }
    
    func didTapOnBankPicker(documentId: String?) {
        guard let documentId else { return }
        Log("Tapped on Bank Picker on :\(documentId)", event: .success)
        let bankSelectionBottomSheet = paymentComponentsController.bankSelectionBottomSheet()
        bankSelectionBottomSheet.modalPresentationStyle = .overFullScreen
        self.coordinator.invoicesListViewController.present(bankSelectionBottomSheet, animated: false)
    }

    func didTapOnPayInvoice(documentId: String?) {
        guard let documentId else { return }
        Log("Tapped on Pay Invoice on :\(documentId)", event: .success)
        documentIDToRefetch = documentId
        paymentComponentsController.loadPaymentReviewScreenFor(documentID: documentId, trackingDelegate: self) { [weak self] viewController, error in
            if let error {
                self?.errors.append(error.localizedDescription)
                self?.showErrorsIfAny()
            } else if let viewController {
                viewController.modalTransitionStyle = .coverVertical
                viewController.modalPresentationStyle = .overCurrentContext
                self?.shouldRefetchExtractions = true
                self?.coordinator.invoicesListViewController.present(viewController, animated: true)
            }
        }
    }
}

extension InvoicesListViewModel: PaymentComponentsControllerProtocol {
    func didFetchedPaymentProviders() {
        DispatchQueue.main.async {
            self.coordinator.invoicesListViewController.reloadTableView()
        }
    }

    func isLoadingStateChanged(isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                self.coordinator.invoicesListViewController.showActivityIndicator()
            } else {
                self.coordinator.invoicesListViewController.hideActivityIndicator()
            }
        }
    }
}

extension InvoicesListViewModel: PaymentProvidersBottomViewProtocol {
    func didSelectPaymentProvider(paymentProvider: PaymentProvider) {
        DispatchQueue.main.async {
            self.coordinator.invoicesListViewController.presentedViewController?.dismiss(animated: true)
            self.coordinator.invoicesListViewController.reloadTableView()
        }
    }
    
    func didTapOnClose() {
        DispatchQueue.main.async {
            self.coordinator.invoicesListViewController.presentedViewController?.dismiss(animated: true)
        }
    }
}

extension InvoicesListViewModel: GiniHealthTrackingDelegate {
    func onPaymentReviewScreenEvent(event: TrackingEvent<PaymentReviewScreenEventType>) {
        switch event.type {
        case .onToTheBankButtonClicked:
            Log("To the banking app button was tapped,\(String(describing: event.info))", event: .success)
        case .onCloseButtonClicked:
            refetchExtractions()
            Log("Close screen was triggered", event: .success)
        case .onCloseKeyboardButtonClicked:
            Log("Close keyboard was triggered", event: .success)
        }
    }
}
