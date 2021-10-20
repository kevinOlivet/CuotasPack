//
//  BankSelectCleanWorkerTests.swift
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
import OHHTTPStubs
import XCTest

class BankSelectCleanWorkerTests: XCTestCase {
    // MARK: Subject under test

    var sut: BankSelectCleanWorker!
    var reachabilitySpy: ReachabilityCheckingProtocol?
    let stubs = CuotasModuleStubs(logging: true, verbose: true)

    // MARK: Test lifecycle

    override  func setUp() {
        super.setUp()
        setupBankSelectCleanWorker()
        stubs.removeAllStubs()
        HTTPStubs.removeAllStubs()
    }

    override  func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: Test setup

    func setupBankSelectCleanWorker() {
        sut = BankSelectCleanWorker()
    }

    // MARK: Tests

    func testGetBankSelectSuccess() {
        // Given
        stubs.registerStub(
            for: Configuration.Api.bankSelect,
            jsonFile: "GET_bank_select_200.json",
            stubName: "Bank select stub",
            downloadSpeed: OHHTTPStubsDownloadSpeedWifi,
            responseTime: 1,
            replaceIfExists: false
        )
        let expectation = self.expectation(description: "calls the callback with a resource object")
        // When
        sut.getBankSelect(
            selectedPaymentMethodId: "testMethod",
            successCompletion: { (bankSelectResult) in
                // Then
                XCTAssertEqual(
                    bankSelectResult?.first?.name,
                    "Mercado Pago + Banco Patagonia",
                    "should match the JSON file"
                )
                XCTAssertEqual(
                    bankSelectResult?.first?.id,
                    "1078",
                    "should match the JSON file"
                )
                XCTAssertEqual(
                    bankSelectResult?.first?.secureThumbnail,
                    "https://http2.mlstatic.com/storage/logos-api-admin/dbf74650-b234-11e9-b872-f9cdde9240f0-m@2x.png",
                    "should match the JSON file"
                )
                expectation.fulfill()
        }) { _ in
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
        stubs.removeStub(stubName: "Bank select Stub")
        HTTPStubs.removeAllStubs()
    }

    func testGetBankSelectFail() {
        // Given
        stubs.registerStub(
            for: Configuration.Api.paymentMethods,
            jsonFile: "GET_bank_select_200.json",
            stubName: "Bank select Stub (general error)",
            responseTime: 1,
            failWithInternetError: true
        )

        let expectation = self.expectation(description: "network down")

        // When
        sut.getBankSelect(
            selectedPaymentMethodId: "testPaymentId", 
            successCompletion: { _ in
        }) { error in
            XCTAssertNotNil(
                error,
                "no internet error returns an error"
            )
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
        stubs.removeStub(stubName: "Bank select Stub (general error)")
        HTTPStubs.removeAllStubs()
    }

    func testGetBankSelectNoInternet() {
        // Given
        let reachabilitySpy = ReachabilitySpy()
        reachabilitySpy.isConnectedToNetworkReturnValue = false
        sut.reachability = reachabilitySpy

        let expectation = self.expectation(description: "network is down!")

        // When
        sut.getBankSelect(
            selectedPaymentMethodId: "testPaymentId",
            successCompletion: { _ in
        }) { error in
            switch error.error {
            case .NO_INTERNET:
                expectation.fulfill()
                return

            default:
                return
            }
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
        HTTPStubs.removeAllStubs()
    }
}

// swiftlint:enable line_length
// swiftlint:enable implicitly_unwrapped_optional
// swiftlint:enable identifier_name
// swiftlint:enable force_cast
// swiftlint:enable file_length
// swiftlint:enable superfluous_disable_command
