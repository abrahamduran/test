//
//  MockMoneyRepository.swift
//  MoneyTests
//
//  Created by Abraham Duran on 9/22/23.
//

import Foundation
@testable import Money

final class MockMoneyRepository: MoneyRepository {
    var account: Account?
    var transactions: TransactionPage?
    var saveAccountAction: ((Account) -> Void)?
    var saveTransactionsAction: ((TransactionPage) -> Void)?

    func getAccount() async -> Account? { account }
    func saveAccount(_ account: Account) async { saveAccountAction?(account) }

    func getTransactions() async -> TransactionPage? { transactions }
    func saveTransactions(_ transactions: TransactionPage) async { saveTransactionsAction?(transactions) }
}
