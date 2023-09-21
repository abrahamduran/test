//
//  TransactionList.swift
//  Money
//
//  Created by Abraham Duran on 9/21/23.
//

import SwiftUI

struct TransactionList: View {
    let transactions: [Transaction]

    var body: some View {
        List(transactions) { transaction in
            VStack {
                HStack {
                    Text(transaction.title)
                        .font(.subheadline.bold())

                    Spacer()

                    Text(transaction.amountFormatted)
                        .font(.callout)
                }

                Color(.separator)
                    .frame(height: 1)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

#Preview {
    TransactionList(transactions: [
        Transaction(id: UUID(), title: "Shell Gasoline", amount: 12.3, currency: "USD"),
        Transaction(id: UUID(), title: "Fred Meyer", amount: 11.0, currency: "USD"),
        Transaction(id: UUID(), title: "Taco Bell", amount: 2.4, currency: "USD"),
        Transaction(id: UUID(), title: "Flagstar Loan", amount: 1911.02, currency: "USD"),
        Transaction(id: UUID(), title: "Al’s Mini Mart", amount: 6.88, currency: "USD"),
        Transaction(id: UUID(), title: "Madewell", amount: 210.2, currency: "USD"),
        Transaction(id: UUID(), title: "Century Link", amount: 49.99, currency: "USD"),
        Transaction(id: UUID(), title: "Tom’s Diner", amount: 17.11, currency: "USD"),
        Transaction(id: UUID(), title: "Dropbox", amount: 9.99, currency: "USD"),
        Transaction(id: UUID(), title: "Nintendo Switch Online", amount: 4.99, currency: "USD")
    ])
}
