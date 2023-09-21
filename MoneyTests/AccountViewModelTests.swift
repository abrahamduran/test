//
//  AccountViewModelTests.swift
//  MoneyTests
//
//  Created by Philippe Boudreau on 2023-08-15.
//

import XCTest
@testable import Money

final class AccountViewModelTests: XCTestCase {

    @MainActor func testFetchAccountData() async {
        let viewModel = AccountViewModel()

        XCTAssertEqual(viewModel.accountBalance, .loading)

        await viewModel.fetchData()

        XCTAssertNotEqual(viewModel.accountBalance, .loading)
    }

    @MainActor func testFetchTrasanctionsData() async {
        let viewModel = AccountViewModel()

        XCTAssertEqual(viewModel.transactions, .loading)

        await viewModel.fetchData()

        XCTAssertNotEqual(viewModel.transactions, .loading)
    }
}
