//
//  PaymentMethodCleanInteractorTests.swift
//  CuotasModule
//
//  Copyright © 2018 Banco de Crédito e Inversiones. All rights reserved.
//

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable force_cast
// swiftlint:disable identifier_name
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable line_length

import CommonsPack
@testable import CuotasPack
import XCTest

class PaymentMethodCleanInteractorTests: XCTestCase {
    // MARK: Subject under test

    var sut: PaymentMethodCleanInteractor!
    var spyPresenter: PaymentMethodCleanPresentationLogicSpy!
    var spyWorker: PaymentMethodCleanWorkerSpy!

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupPaymentMethodCleanInteractor()
    }

    override  func tearDown() {
        spyPresenter = nil
        spyWorker = nil
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupPaymentMethodCleanInteractor() {
        sut = PaymentMethodCleanInteractor()

        spyPresenter = PaymentMethodCleanPresentationLogicSpy()
        sut.presenter = spyPresenter

        spyWorker = PaymentMethodCleanWorkerSpy()
        sut.worker = spyWorker
    }

    // MARK: Test doubles

    enum PossibleResults {
        case success
        case parsingFail
        case failure
    }

    class PaymentMethodCleanWorkerSpy: PaymentMethodCleanWorker {

        var theResult: PossibleResults = .success

        override func getPaymentMethods(
            successCompletion: @escaping ([PaymentMethodModel]?) -> Void,
            failureCompletion: @escaping (APIManagerError) -> Void
        ) {
            switch theResult {
            case .success:
                let model = PaymentMethodModel(
                    name: "testName",
                    id: "testId",
                    secureThumbnail: "testThumbnail",
                    paymentTypeId: "testPaymentTypeId",
                    minAllowedAmount: 123,
                    maxAllowedAmount: 12334
                )
                successCompletion([model])
            case .parsingFail:
                successCompletion(nil)
            case .failure:
                let error = APIManagerError(.NO_INTERNET)
                failureCompletion(error)
            }
        }
    }

    // MARK: Tests

     func testPrepareSetUpUI() {
        // Given
        sut.amountEntered = 1234
        let request = PaymentMethodClean.Texts.Request()
        // When
        sut.prepareSetUpUI(request: request)
        // Then
        XCTAssertTrue(
            spyPresenter.presentSetupUICalled,
            "doSomething(request:) should ask the presenter to format the result"
        )
        XCTAssertEqual(
            spyPresenter.presentSetupUIResponse?.title,
            1234,
            "should pass the amount entered to the presenter to setup the UI"
        )
    }
    func testFetchPaymentMethodsSuccess() {
        // Given
        spyWorker.theResult = .success
        let request = PaymentMethodClean.PaymentMethods.Request()
        // When
        sut.fetchPaymentMethods(request: request)
        // Then
        XCTAssertTrue(
            spyPresenter.presentPaymentMethodsCalled,
            "fetchPaymentMethods with success should call presenter presentPaymentMethods"
        )
    }
    func testFetchPaymentMethodsParsingFail() {
        // Given
        spyWorker.theResult = .parsingFail
        let request = PaymentMethodClean.PaymentMethods.Request()
        // When
        sut.fetchPaymentMethods(request: request)
        // Then
        XCTAssertTrue(
            spyPresenter.presentErrorAlertCalled,
            "fetchPaymentMethods with failure parsing should call presenter presentErrorAlert"
        )
        XCTAssertEqual(
            spyPresenter.presentErrorAlertResponse?.errorType,
            .service,
            "Error parsing should have a title Error"
        )
    }
    func testFetchPaymentMethodsGeneralFail() {
        // Given
        spyWorker.theResult = .failure
        let request = PaymentMethodClean.PaymentMethods.Request()
        // When
        sut.fetchPaymentMethods(request: request)
        // Then
        XCTAssertTrue(
            spyPresenter.presentErrorAlertCalled,
            "fetchPaymentMethods with failure should call presenter presentErrorAlert"
        )
        XCTAssertEqual(
            spyPresenter.presentErrorAlertResponse?.errorType,
            .internet,
            "Error in general should have a title Error"
        )

    }
    func testHandleDidSelectRowAmountSuccess() {
        // Given
        let model = PaymentMethodModel(
            name: "testName",
            id: "testId",
            secureThumbnail: "testThumbnail",
            paymentTypeId: "testPaymentTypeId",
            minAllowedAmount: 123,
            maxAllowedAmount: 12345
        )
        sut.paymentMethodArray = [model]
        sut.amountEntered = 1234
        let request = PaymentMethodClean.PaymentMethodsDetails.Request(indexPath: 0)
        // When
        sut.handleDidSelectRow(request: request)
        // Then
        XCTAssertTrue(
            spyPresenter.showBankSelectCalled,
            "handleDidSelectRow success should call presenter showBankSelect"
        )
        XCTAssertEqual(
            spyPresenter.showBankSelectResponse?.amountEntered,
            1234,
            "should match the amount entered"
        )
        XCTAssertEqual(
            spyPresenter.showBankSelectResponse?.selectedPaymentMethod.name,
            "testName", "should match the model info"
        )
    }
    func testHandleDidSelectRowAmountTooMuch() {
        // Given
        let model = PaymentMethodModel(
            name: "testName",
            id: "testId",
            secureThumbnail: "testThumbnail",
            paymentTypeId: "testPaymentTypeId",
            minAllowedAmount: 123,
            maxAllowedAmount: 1234
        )
        sut.paymentMethodArray = [model]
        sut.amountEntered = 12345
        let request = PaymentMethodClean.PaymentMethodsDetails.Request(indexPath: 0)
        // When
        sut.handleDidSelectRow(request: request)
        // Then
        XCTAssertTrue(
            spyPresenter.presentAmountErrorAlertCalled,
            "handleDidSelectRow with too much should call presenter presentErrorAlert"
        )
        XCTAssertEqual(
            spyPresenter.presentAmountErrorAlertResponse?.errorTitle,
            "CHOOSE_AGAIN",
            "Error for too much should have a title Error"
        )
        XCTAssertEqual(
            spyPresenter.presentAmountErrorAlertResponse?.errorMessage,
            "testName has a minimum amount of 123.00 and a maximum amount of 1234.00", "Error in general should have a message specific message"
            )
        XCTAssertEqual(
            spyPresenter.presentAmountErrorAlertResponse?.buttonTitle,
            "BIG_UNDERSTOOD",
            "Error for too much should have a button UNDERSTOOD"
        )
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
