//
//  MockMoneyService.swift
//  MoneyTests
//
//  Created by Abraham Duran on 9/22/23.
//

import Foundation
import Combine
@testable import Money

final class MockMoneyService: MoneyServiceProtocol {
    var account: Account?
    var transactions: TransactionPage?
    var isBusy: AnyPublisher<Bool, Never> = PassthroughSubject().eraseToAnyPublisher()

    func getAccount() async throws -> Account {
        guard let account else {
            throw MoneyServiceError.serverError
        }
        return account
    }
    
    func getTransactions(page: Int, limit: Int) async throws -> Money.TransactionPage {
        guard let transactions else {
            throw MoneyServiceError.serverError
        }
        return transactions
    }
}
