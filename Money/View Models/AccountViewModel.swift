//
//  AccountViewModel.swift
//  Money
//
//  Created by Philippe Boudreau on 2023-08-15.
//

import Foundation
import Combine

@MainActor class AccountViewModel: ObservableObject {
    private enum Constants {
        static let pageSize = 10
    }

    enum ViewState<T: Equatable>: Equatable {
        case loading
        case content(T)
    }

    @Published private(set) var accountBalance: ViewState<String> = .loading

    private let moneyService = MoneyService()
    private var cancellables = Set<AnyCancellable>()

    init() { }

    func fetchAccountData() async {
        do {
            let account = try await moneyService.getAccount()
            accountBalance = .content(account.balance.formatted(.currency(code: account.currency)))
        } catch {
            // TODO: some error handling
        }
    }

    private func fetchTransactions() async {
        do {
            let page = try await moneyService.getTransactions(page: 0, limit: Constants.pageSize)
            transactions = .content(page.transactions)
        } catch {
            // TODO: some error handling
        }
    }
}
