//
//  AccountView.swift
//  Money
//
//  Created by Philippe Boudreau on 2023-08-15.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject private var launchScreenStateManager: LaunchScreenStateManager
    @StateObject private var viewModel = AccountViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Account Balance")
                .font(.subheadline)
                .bold()

            HStack {
                accountBalance

                Spacer()

                networkIndicator
            }
            .animation(.default, value: viewModel.accountBalance)

            VStack {
                switch viewModel.transactions {
                case .loading:
                    Spacer()

                    ProgressView()
                        .frame(maxWidth: .infinity)

                    Spacer()
                case .content(let transactions):
                    TransactionList(transactions: transactions)
                case .error:
                    errorView
                }
            }
            .animation(.default, value: viewModel.transactions)

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.leading, .trailing], 28)
        .padding(.top)
        .task {
            // Workaround to overcome the limitations of SwiftUI's launch screen feature.
            try? await Task.sleep(for: Duration.seconds(1))
            launchScreenStateManager.dismissLaunchScreen()

            Task {
                await viewModel.fetchData()
            }
        }
    }

    @ViewBuilder
    private var accountBalance: some View {
        switch viewModel.accountBalance {
        case .loading:
            ProgressView()
        case .content(let balance):
            Text(balance)
                .font(.largeTitle)
                .bold()
        case .error:
            EmptyView()
        }
    }

    private var networkIndicator: some View {
        HStack {
            switch viewModel.networkState {
            case .offline:
                Image(systemName: "wifi.slash")
                    .foregroundStyle(.red)
            case .online:
                Image(systemName: "wifi")
            case .refreshing:
                ProgressView()
            }
        }
        .animation(.default, value: viewModel.networkState)
    }

    @ViewBuilder
    private var errorView: some View {
        Spacer()

        Image(systemName: "exclamationmark.triangle.fill")
            .foregroundStyle(.gray)
            .font(.largeTitle)
            .frame(maxWidth: .infinity)

        Text("An error has ocurred")
            .font(.headline.bold())
            .foregroundStyle(.gray.opacity(0.7))

        Button("Retry") {
            Task { await viewModel.retry() }
        }
        .buttonStyle(.borderedProminent)

        Spacer()
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(LaunchScreenStateManager())
    }
}
