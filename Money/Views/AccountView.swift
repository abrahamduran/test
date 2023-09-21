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
                switch viewModel.accountBalance {
                case .loading:
                    ProgressView()
                case .content(let balance):
                    Text(balance)
                        .font(.largeTitle)
                        .bold()
                }
            }
            .animation(.default, value: viewModel.accountBalance)

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
                await viewModel.fetchAccountData()
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(LaunchScreenStateManager())
    }
}
