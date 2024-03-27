import XCTest
@testable import GiniHealthSDK
@testable import GiniHealthAPILibrary

final class GiniHealthTests: XCTestCase {
    
    var giniHealthAPI: HealthAPI!
    var giniHealth: GiniHealth!
    
    override func setUp() {
        let sessionManagerMock = MockSessionManager()
        let documentService = DefaultDocumentService(sessionManager: sessionManagerMock)
        let paymentService = PaymentService(sessionManager: sessionManagerMock)
        giniHealthAPI = MockHealthAPI(docService: documentService, payService: paymentService)
        giniHealth = GiniHealth(with: giniHealthAPI)
    }

    override func tearDown() {
        giniHealth = nil
        super.tearDown()
    }
    
    func testSetConfiguration() throws {
        // Given
        let configuration = GiniHealthConfiguration()
        
        // When
        giniHealth.setConfiguration(configuration)
        
        // Then
        XCTAssertEqual(GiniHealthConfiguration.shared, configuration)
    }
    
    func testFetchBankingApps_Success() {
        // Given
        let expectedProviders: [PaymentProvider] = loadProviders()
        
        // When
        let expectation = self.expectation(description: "Fetching banking apps")
        var receivedProviders: [PaymentProvider]?
        giniHealth.fetchBankingApps { result in
            switch result {
            case .success(let providers):
                receivedProviders = providers
            case .failure(_):
                receivedProviders = nil
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        XCTAssertNotNil(receivedProviders)
        XCTAssertEqual(receivedProviders?.count, expectedProviders.count)
        XCTAssertEqual(receivedProviders, expectedProviders)
    }

    func testCheckIfDocumentIsPayable_Success() {
        // Given
        let expectedExtractions: ExtractionsContainer = loadExtractionResults(fileName: "extractionResultWithIBAN", type: "json")
        let expectedExtractionsResult = ExtractionResult(extractionsContainer: expectedExtractions)
        let expectedIsPayable = expectedExtractionsResult.extractions.first(where: { $0.name == "iban" })?.value.isNotEmpty
        
        // When
        let expectation = self.expectation(description: "Checking if document is payable")
        var isDocumentPayable: Bool?
        giniHealth.checkIfDocumentIsPayable(docId: MockSessionManager.payableDocumentID) { result in
            switch result {
            case .success(let isPayable):
                isDocumentPayable = isPayable
            case .failure(_):
                isDocumentPayable = nil
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

        // Then
        XCTAssertEqual(expectedIsPayable, isDocumentPayable)
    }
    
    func testCheckIfDocumentIsNotPayable_Success() {
        // Given
        let expectedExtractions: ExtractionsContainer = loadExtractionResults(fileName: "extractionResultWithIBAN", type: "json")
        let expectedExtractionsResult = ExtractionResult(extractionsContainer: expectedExtractions)
        let expectedIsPayable = expectedExtractionsResult.extractions.first(where: { $0.name == "iban" })?.value.isEmpty
        
        // When
        let expectation = self.expectation(description: "Checking if document is not payable")
        var isDocumentPayable: Bool?
        giniHealth.checkIfDocumentIsPayable(docId: MockSessionManager.notPayableDocumentID) { result in
            switch result {
            case .success(let isPayable):
                isDocumentPayable = isPayable
            case .failure(_):
                isDocumentPayable = nil
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

        // Then
        XCTAssertEqual(expectedIsPayable, isDocumentPayable)
    }
    
    func testCheckIfDocumentIsPayable_Failure() {
        // When
        let expectation = self.expectation(description: "Checking if request fails")
        var isDocumentPayable: Bool?
        giniHealth.checkIfDocumentIsPayable(docId: MockSessionManager.failurePayableDocumentID) { result in
            switch result {
            case .success(let isPayable):
                isDocumentPayable = isPayable
            case .failure(_):
                isDocumentPayable = nil
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

        // Then
        XCTAssertNil(isDocumentPayable)
    }
    
    func testPollDocument_Success() {
        // Given
        let expectedDocument: Document = loadDocument(fileName: "document1", type: "json")

        // When
        let expectation = self.expectation(description: "Polling document")
        var receivedDocument: Document?
        giniHealth.pollDocument(docId: MockSessionManager.payableDocumentID) { result in
            switch result {
            case .success(let document):
                receivedDocument = document
            case .failure(_):
                receivedDocument = nil
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

        // Then
        XCTAssertNotNil(receivedDocument)
        XCTAssertEqual(receivedDocument!, expectedDocument)
    }
    
    func testPollDocument_Failure() {
        // When
        let expectation = self.expectation(description: "Polling failure document")
        var receivedDocument: Document?
        giniHealth.pollDocument(docId: MockSessionManager.missingDocumentID) { result in
            switch result {
            case .success(let document):
                receivedDocument = document
            case .failure(_):
                receivedDocument = nil
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

        // Then
        XCTAssertNil(receivedDocument)
    }
    
    func testGetExtractions_Success() {
        // Given
        let expectedExtractionContainer: ExtractionsContainer = loadExtractionResults(fileName: "extractionsWithPayment", type: "json")
        let expectedExtractions: [Extraction] = ExtractionResult(extractionsContainer: expectedExtractionContainer).payment?.first ?? []

        // When
        let expectation = self.expectation(description: "Getting extractions")
        var receivedExtractions: [Extraction]?
        giniHealth.getExtractions(docId: MockSessionManager.extractionsWithPaymentDocumentID) { result in
            switch result {
            case .success(let extractions):
                receivedExtractions = extractions
            case .failure(_):
                receivedExtractions = nil
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

        // Then
        XCTAssertNotNil(receivedExtractions)
        XCTAssertEqual(receivedExtractions!.count, expectedExtractions.count)
    }
    
    func testGetExtractions_Failure() {
        // When
        let expectation = self.expectation(description: "Extraction failure")
        var receivedExtractions: [Extraction]?
        giniHealth.getExtractions(docId: MockSessionManager.failurePayableDocumentID) { result in
            switch result {
            case .success(let extractions):
                receivedExtractions = extractions
            case .failure(_):
                receivedExtractions = nil
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

        // Then
        XCTAssertNil(receivedExtractions)
    }
    
    func testCreatePaymentRequest_Success() {
        // Given
        let expectedPaymentRequestID = MockSessionManager.paymentRequestId

        // When
        let expectation = self.expectation(description: "Creating payment request")
        var receivedRequestId: String?
        let paymentInfo = PaymentInfo(recipient: "Uno Flüchtlingshilfe", iban: "DE78370501980020008850", bic: "COLSDE33", amount: "1.00:EUR", purpose: "ReNr 12345", paymentUniversalLink: "ginipay-test://paymentRequester", paymentProviderId: "b09ef70a-490f-11eb-952e-9bc6f4646c57")
        giniHealth.createPaymentRequest(paymentInfo: paymentInfo, completion: { result in
            switch result {
            case .success(let requestId):
                receivedRequestId = requestId
            case .failure(_):
                receivedRequestId = nil
            }
            expectation.fulfill()
        })
        waitForExpectations(timeout: 1, handler: nil)

        // Then
        XCTAssertNotNil(receivedRequestId)
        XCTAssertEqual(receivedRequestId!, expectedPaymentRequestID)
    }
    
    func testOpenWebsite_Success() {
        let mockUIApplication = MockUIApplication(canOpen: true)
        let urlOpener = URLOpener(mockUIApplication)
        let waitForWebsiteOpen = expectation(description: "Web site was opened!")

        giniHealth.openPaymentProviderApp(requestID: "123", universalLink: "ginipay-bank://", urlOpener: urlOpener, completion: { open in
            waitForWebsiteOpen.fulfill()
            XCTAssert(open == true, "testOpenWebsite - FAILED to open web site")
        })

        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testOpenWebsite_Failure() {
        let mockUIApplication = MockUIApplication(canOpen: false)
        let urlOpener = URLOpener(mockUIApplication)
        let waitForWebsiteOpen = expectation(description: "Web site was not opened!")

        giniHealth.openPaymentProviderApp(requestID: "123", universalLink: "ginipay-bank://", urlOpener: urlOpener, completion: { open in
            waitForWebsiteOpen.fulfill()
            XCTAssert(open == false, "testOpenWebsite - MANAGED to open web site")
        })

        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testSetDocumentForReview_Success() {
        // Given
        let expectedExtractionContainer: ExtractionsContainer = loadExtractionResults(fileName: "extractionsWithPayment", type: "json")
        let expectedExtractions: [Extraction] = ExtractionResult(extractionsContainer: expectedExtractionContainer).payment?.first ?? []

        // When
        let expectation = self.expectation(description: "Setting document for review")
        var receivedExtractions: [Extraction]?
        giniHealth.setDocumentForReview(documentId: MockSessionManager.extractionsWithPaymentDocumentID) { result in
            switch result {
            case .success(let extractions):
                receivedExtractions = extractions
            case .failure(_):
                receivedExtractions = nil
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

        // Then
        XCTAssertNotNil(receivedExtractions)
        XCTAssertEqual(receivedExtractions!.count, expectedExtractions.count)
    }
    
    func testFetchDataForReview_Success() {
        // Given
        let expectedExtractionContainer: ExtractionsContainer = loadExtractionResults(fileName: "extractionsWithPayment", type: "json")
        let expectedExtractions: [Extraction] = ExtractionResult(extractionsContainer: expectedExtractionContainer).payment?.first ?? []
        let expectedDocument: Document = loadDocument(fileName: "document4", type: "json")
        let expectedDatForReview = DataForReview(document: expectedDocument, extractions: expectedExtractions)

        // When
        let expectation = self.expectation(description: "Fetching data for review")
        var receivedDataForReview: DataForReview?
        giniHealth.fetchDataForReview(documentId: MockSessionManager.extractionsWithPaymentDocumentID) { result in
            switch result {
            case .success(let dataForReview):
                receivedDataForReview = dataForReview
            case .failure(_):
                receivedDataForReview = nil
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

        // Then
        XCTAssertNotNil(receivedDataForReview)
        XCTAssertEqual(receivedDataForReview!.document, expectedDatForReview.document)
        XCTAssertEqual(receivedDataForReview!.extractions.count, expectedDatForReview.extractions.count)
    }
    
    func testFetchDataForReview_Failure() {
        // When
        let expectation = self.expectation(description: "Failure fetching data for review")
        var receivedError: GiniHealthError?
        giniHealth.fetchDataForReview(documentId: MockSessionManager.missingDocumentID) { result in
            switch result {
            case .success(_):
                receivedError = nil
            case .failure(let error):
                receivedError = error
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

        // Then
        XCTAssertNotNil(receivedError)
    }
}

