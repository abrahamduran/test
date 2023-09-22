//
//  MoneyRepository.swift
//  Money
//
//  Created by Abraham Duran on 9/21/23.
//

import Foundation

protocol MoneyRepository {
    func getAccount() async -> Account?
    func getTransactions() async -> TransactionPage?
    func saveAccount(_ account: Account) async
    func saveTransactions(_ transactions: TransactionPage) async
}

final class UserDefaultMoneyRepository: MoneyRepository {
    enum Key: String {
        case account, transactions
    }
    private let store: UserDefaults

    init(store: UserDefaults = .standard) {
        self.store = store
    }

    func getAccount() async -> Account? {
        await get(forKey: .account)
    }

    func saveAccount(_ account: Account) async {
        await save(account, forKey: .account)
    }

    func getTransactions() async -> TransactionPage? {
        await get(forKey: .transactions)
    }

    func saveTransactions(_ transactions: TransactionPage) async {
        await save(transactions, forKey: .transactions)
    }

    private func get<T: Decodable>(forKey key: Key) async -> T? {
        await Task.detached {
            let decoder = JSONDecoder()
            if let data = self.store.data(forKey: key.rawValue) {
                return try? decoder.decode(T.self, from: data)
            }
            return nil
        }
        .value
    }

    private func save<T: Encodable>(_ value: T, forKey key: Key) async {
        await Task.detached {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(value) {
                self.store.set(encoded, forKey: key.rawValue)
            }
        }
        .value
    }
}
