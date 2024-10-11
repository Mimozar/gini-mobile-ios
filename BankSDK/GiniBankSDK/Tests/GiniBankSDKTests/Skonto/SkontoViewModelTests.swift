//
//  PP-845-iOS-SkontoViewModelTests-unit-tests-for-Skonto-RA.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//

import XCTest
@testable import GiniBankSDK
@testable import GiniBankAPILibrary

class SkontoViewModelTests: XCTestCase {
    
    var viewModel: SkontoViewModel!
    var skontoDiscounts: SkontoDiscounts!
    
    override func setUp() {
        super.setUp()
        let fileURLPath: String? = Bundle.module
            .path(forResource: "skontoDiscounts", ofType: "json")
        let data = try? Data.init(contentsOf: URL(fileURLWithPath: fileURLPath!))
        guard let data else {
            XCTFail("Missing file: skontoDiscounts.json")
            return
        }
        
        do {
            let extractionsContainer = try JSONDecoder().decode(ExtractionsContainer.self, from: data)
            let extractionResult = ExtractionResult(extractionsContainer: extractionsContainer)
            skontoDiscounts = try SkontoDiscounts(extractions: extractionResult)
            viewModel = SkontoViewModel(skontoDiscounts: skontoDiscounts)
        } catch {
            XCTFail("Failed to decode JSON: \(error)")
        }
    }
    
    override func tearDown() {
        viewModel = nil
        skontoDiscounts = nil
        super.tearDown()
    }
    
    func testViewModelInitialization() {
        XCTAssertEqual(viewModel.amountToPay,
                       skontoDiscounts.totalAmountToPay,
                       "Amount to pay should be initialized correctly.")
        XCTAssertEqual(viewModel.skontoAmountToPay,
                       skontoDiscounts.discounts[0].amountToPay,
                       "Skonto amount to pay should be initialized correctly.")
        XCTAssertEqual(viewModel.dueDate,
                       skontoDiscounts.discounts[0].dueDate,
                       "Due date should be initialized correctly.")
        XCTAssertEqual(viewModel.amountDiscounted,
                       skontoDiscounts.discounts[0].amountDiscounted,
                       "Amount discounted should be initialized correctly.")
        XCTAssertEqual(viewModel.currencyCode,
                       skontoDiscounts.discounts[0].amountToPay.currencyCode,
                       "Currency code should match the amount to pay.")
    }
    
    func testStateChangeHandlerIsCalled() {
        var handlerCalled = false
        viewModel.addStateChangeHandler {
            handlerCalled = true
        }

        viewModel.toggleDiscount()
        XCTAssertTrue(handlerCalled,
                      "State change handler should be called when a state-changing action occurs.")
    }
    
    func testToggleDiscount() {
        let initialState = viewModel.isSkontoApplied
        viewModel.toggleDiscount()
        XCTAssertNotEqual(viewModel.isSkontoApplied,
                          initialState,
                          "Toggling discount should change the `isSkontoApplied` state.")
    }
    
    func testRecalculateRemainingDays() {
        let remainingDays = 5
        let newDate = Calendar.current.date(byAdding: .day, value: remainingDays, to: Date())!
        viewModel.setExpiryDate(newDate)
        XCTAssertEqual(viewModel.remainingDays,
                       remainingDays,
                       "Remaining days should be recalculated correctly when the expiry date changes.")
    }
    
    func testExpiredDiscountEdgeCase() {
        let pastDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        viewModel.setExpiryDate(pastDate)
        XCTAssertEqual(viewModel.edgeCase,
                       .expired,
                       "Edge case should be set to 'expired' when the expiry date is in the past.")
    }

    func testPaymentTodayEdgeCase() {
        let todayDate = Date()
        viewModel.setExpiryDate(todayDate)
        XCTAssertEqual(viewModel.edgeCase,
                       .paymentToday,
                       "Edge case should be 'payment today' when the expiry date is today.")
    }
    
    func testEditedExtractionResult() {
        let extractionResult = viewModel.editedExtractionResult
        let skontoDiscountsExtractions = extractionResult.skontoDiscounts?.first
        let amountToPayExtraction = extractionResult.extractions.first { $0.name == "amountToPay" }
        XCTAssertEqual(amountToPayExtraction?.value,
                       viewModel.finalAmountToPay.extractionString,
                       "Edited extraction result should reflect the final amount to pay.")
        
        let skontoAmountToPayExtraction = skontoDiscountsExtractions?.first {
            $0.name == "skontoAmountToPay" || $0.name == "skontoAmountToPayCalculated"
        }
        XCTAssertEqual(skontoAmountToPayExtraction?.value,
                       viewModel.skontoAmountToPay.extractionString,
                       "Edited extraction result should reflect the updated skonto amount to pay.")
        
        let skontoDueDateExtraction = skontoDiscountsExtractions?.first {
            $0.name == "skontoDueDate" || $0.name == "skontoDueDateCalculated"
        }
        XCTAssertEqual(skontoDueDateExtraction?.value,
                       viewModel.dueDate.yearMonthDayString,
                       "Edited extraction result should reflect the updated skonto due date.")
        
        let skontoPercentageDiscountedExtraction = skontoDiscountsExtractions?.first {
            $0.name == "skontoPercentageDiscounted" || $0.name == "skontoPercentageDiscountedCalculated"
        }
        XCTAssertEqual(skontoPercentageDiscountedExtraction?.value,
                       viewModel.formattedPercentageDiscounted,
                       "Edited extraction result should reflect the updated skonto percentage discounted.")
        
        let skontoAmountDiscountedExtraction = skontoDiscountsExtractions?.first {
            $0.name == "skontoAmountDiscounted" || $0.name == "skontoAmountDiscountedCalculated"
        }
        XCTAssertEqual(skontoAmountDiscountedExtraction?.value,
                       viewModel.amountDiscounted.extractionString,
                       "Edited extraction result should reflect the updated skonto amount discounted.")
        
        let skontoRemainingDaysExtraction = skontoDiscountsExtractions?.first { $0.name == "skontoRemainingDays" }
        XCTAssertEqual(skontoRemainingDaysExtraction?.value,
                       "\(viewModel.remainingDays)",
                       "Edited extraction result should reflect the updated skonto remaining days.")
    }

    func testSetSkontoAmountToPayPrice() {
        let newPrice = 90.00
        viewModel.setSkontoAmountToPayPrice(formatValue(newPrice))

        XCTAssertEqual(viewModel.skontoAmountToPay.value,
                       Decimal(newPrice),
                       "Skonto amount to pay should be updated correctly when a new price is set.")
    }

    func testSetAmountToPayPrice() {
        let newPrice = 120.00
        viewModel.setAmountToPayPrice(formatValue(newPrice))

        XCTAssertEqual(viewModel.amountToPay.value,
                       Decimal(newPrice),
                       "Amount to pay should be updated correctly when a new price is set.")
    }
    
    func testSetInvalidSkontoAmountToPayPrice() {
        let amountToPayInitialValue = skontoDiscounts.totalAmountToPay.value
        let skontoAmountToPayInitialValue = skontoDiscounts.discounts[0].amountToPay.value
        let newPrice = formatValue(Double(truncating: amountToPayInitialValue as NSNumber) + 1)
        viewModel.setSkontoAmountToPayPrice(newPrice)

        XCTAssertEqual(viewModel.skontoAmountToPay.value,
                       skontoAmountToPayInitialValue,
                       "Skonto amount should remain unchanged if an invalid price is provided.")
    }
    
    private func formatValue(_ value: Double) -> String {
        return NumberFormatter.twoDecimalPriceFormatter.string(from: NSNumber(value: value)) ?? ""
    }
}
