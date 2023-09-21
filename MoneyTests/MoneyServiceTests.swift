//
//  MoneyServiceTests.swift
//  MoneyTests
//
//  Created by Philippe Boudreau on 2023-08-17.
//

import Foundation
import Combine

import XCTest
@testable import Money

final class MoneyServiceTests: XCTestCase {

    private var cancellables = Set<AnyCancellable>()

    func testBusyState() async throws {
        let service = MoneyService()

        var didBecomeBusy = false
        var finalState = false
        service.isBusy
            .sink {
                didBecomeBusy = didBecomeBusy || $0
                finalState = $0
            }
            .store(in: &cancellables)

        let _ = try await service.getAccount()

        XCTAssertTrue(didBecomeBusy)
        XCTAssertFalse(finalState)
    }

    func testGetAccount() async throws {
        let service = MoneyService()

        let account = try await service.getAccount()
        let unwrappedAccount = try XCTUnwrap(account)

        XCTAssertEqual(unwrappedAccount.balance, 12312.01)
        XCTAssertEqual(unwrappedAccount.currency, "USD")
    }

    func testGetTransactions() async throws {
        let service = MoneyService()

        let account = try await service.getTransactions(page: 0, limit: 10)
        let unwrappedAccount = try XCTUnwrap(account)

        XCTAssertEqual(unwrappedAccount.count, 10)
        XCTAssertEqual(unwrappedAccount.total, 22)
        XCTAssertEqual(unwrappedAccount.last, false)
        XCTAssertEqual(unwrappedAccount.transactions.count, 10)
    }
}
