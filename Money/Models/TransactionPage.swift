//
//  TransactionPage.swift
//  Money
//
//  Created by Abraham Duran on 9/20/23.
//

import Foundation

struct TransactionPage: Codable {
    let total: Int
    let count: Int
    let last: Bool
    let transactions: [Transaction]

    enum CodingKeys: String, CodingKey {
        case count, last, total
        case transactions = "data"
    }
}
