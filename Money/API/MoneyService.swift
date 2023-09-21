//
//  MoneyService.swift
//  Money
//
//  Created by Philippe Boudreau on 2023-08-15.
//

import Foundation
import Combine

protocol MoneyServiceProtocol {
    var isBusy: AnyPublisher<Bool, Never> { get }

    func getAccount() async throws -> Account
    func getTransactions(page: Int, limit: Int) async throws -> TransactionPage
}

enum MoneyServiceError: Error {
    case clientError
    case serverError
}

class MoneyService: MoneyServiceProtocol {
    private let _isBusy = PassthroughSubject<Bool, Never>()
    lazy private(set) var isBusy = _isBusy.eraseToAnyPublisher()

    private static let serviceBaseURL = URL(string: "https://8kq890lk50.execute-api.us-east-1.amazonaws.com/prd/accounts/0172bd23-c0da-47d0-a4e0-53a3ad40828f")!
    private let session = URLSession.shared

    func getAccount() async throws -> Account {
        try await getData("balance", queryItems: nil)
    }

    func getTransactions(page: Int, limit: Int) async throws -> TransactionPage {
        let params = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        return try await getData("transactions", queryItems: params)
    }

    private func getData<T: Codable>(_ endpoint: String, queryItems: [URLQueryItem]?) async throws -> T {
        _isBusy.send(true)
        defer { _isBusy.send(false) }

        var dataURL = Self.serviceBaseURL.appending(component: endpoint)
        if let queryItems {
            dataURL.append(queryItems: queryItems)
        }

        do {
            let (data, response) = try await session.data(from: dataURL)

            if let response = response as? HTTPURLResponse, 400..<500 ~= response.statusCode {
                throw MoneyServiceError.clientError
            }

            let object = try JSONDecoder().decode(T.self, from: data)
            return object
        } catch {
            print("Error getting data from \(endpoint): \(error)")
            throw MoneyServiceError.serverError
        }
    }
}
