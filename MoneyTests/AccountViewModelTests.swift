//
//  AccountViewModelTests.swift
//  MoneyTests
//
//  Created by Philippe Boudreau on 2023-08-15.
//

import XCTest
import Combine
@testable import Money

@MainActor
final class AccountViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        cancellables = []
    }

    func testFetchAccountData() async {
        let viewModel = AccountViewModel()

        XCTAssertEqual(viewModel.accountBalance, .loading)

        await viewModel.fetchData()

        XCTAssertNotEqual(viewModel.accountBalance, .loading)
    }

    func testFetchTrasanctionsData() async {
        let viewModel = AccountViewModel()

        XCTAssertEqual(viewModel.transactions, .loading)

        await viewModel.fetchData()

        XCTAssertNotEqual(viewModel.transactions, .loading)
    }

    func testFetchDataSavesOfflineData() async {
        let expected = (
            account: Account(balance: 1200, currency: "DOP"),
            page: TransactionPage(total: 1, count: 1, last: true, transactions: [
                Transaction(id: UUID(), title: "Bravo", amount: 500, currency: "DOP")
            ])
        )
        var results: (account: Account?, page: TransactionPage?) = (nil, nil)
        let api = MockMoneyService()
        api.account = expected.account
        api.transactions = expected.page
        let repository = MockMoneyRepository()
        repository.saveAccountAction = { results.account = $0 }
        repository.saveTransactionsAction = { results.page = $0 }
        let viewModel = AccountViewModel(moneyService: api, repository: repository)

        await viewModel.fetchData()

        XCTAssertEqual(results.account?.balance, expected.account.balance)
        XCTAssertEqual(results.account?.currency, expected.account.currency)
        XCTAssertEqual(results.page?.count, expected.page.count)
        XCTAssertEqual(results.page?.total, expected.page.total)
        XCTAssertEqual(results.page?.last, expected.page.last)
        XCTAssertEqual(results.page?.transactions, expected.page.transactions)
    }

    func testOfflineAccountData() async {
        let expected = (
            account: Account(balance: 1200, currency: "DOP"),
            page: TransactionPage(total: 1, count: 1, last: true, transactions: [
                Transaction(id: UUID(), title: "Bravo", amount: 500, currency: "DOP")
            ])
        )
        let monitor = MockNetworkMonitor()
        monitor.subject.send(.connected)
        let repository = MockMoneyRepository()
        repository.account = expected.account
        repository.transactions = expected.page
        let viewModel = AccountViewModel(moneyService: MockMoneyService(), networkMonitor: monitor, repository: repository)

        monitor.subject.send(.disconnected)
        await viewModel.fetchData()

        XCTAssertEqual(viewModel.accountBalance, .content(expected.account.balanceFormatted))
        XCTAssertEqual(viewModel.transactions, .content(expected.page.transactions))
    }

    func testDataIsRefreshedWhenNetworkIsBackOnline() async throws {
        let expectation = expectation(description: "dataIsRefreshedWhenNetworkIsBackOnline")
        let expected = (
            account: Account(balance: 1200, currency: "DOP"),
            page: TransactionPage(total: 1, count: 1, last: true, transactions: [
                Transaction(id: UUID(), title: "Refreshed", amount: 500, currency: "DOP")
            ])
        )
        let monitor = MockNetworkMonitor()
        monitor.subject.send(.connected)
        let api = MockMoneyService()
        api.account = Account(balance: 100, currency: "DOP")
        api.transactions = TransactionPage(total: 1, count: 1, last: true, transactions: [
            Transaction(id: UUID(), title: "Bravo", amount: 500, currency: "DOP")
        ])
        let viewModel = AccountViewModel(moneyService: api, networkMonitor: monitor)

        viewModel.$networkState
            .collect(5)
            .sink { states in
                XCTAssertEqual(states, [.online, .offline, .online, .refreshing, .online])
                expectation.fulfill()
            }
            .store(in: &cancellables)

        monitor.subject.send(.disconnected)
        try await Task.sleep(for: .milliseconds(500))

        api.account = expected.account
        api.transactions = expected.page
        monitor.subject.send(.connected)
        try await Task.sleep(for: .milliseconds(500))

        XCTAssertEqual(viewModel.accountBalance, .content(expected.account.balanceFormatted))
        XCTAssertEqual(viewModel.transactions, .content(expected.page.transactions))
        XCTAssertEqual(viewModel.networkState, .online)
        await fulfillment(of: [expectation], timeout: 10)
    }
}
