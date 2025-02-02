//
//  Transaction.swift
//  Money
//
//  Created by Abraham Duran on 9/20/23.
//

import Foundation

struct Transaction: Codable, Equatable, Identifiable {
    let id: UUID
    let title: String
    let amount: Double
    let currency: String

    var amountFormatted: String {
        amount.formatted(.currency(code: currency))
    }
}
