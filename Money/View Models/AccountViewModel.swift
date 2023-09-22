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

    enum NetworkState {
        case offline, online, refreshing
    }

    @Published private(set) var accountBalance: ViewState<String> = .loading
    @Published private(set) var transactions: ViewState<[Transaction]> = .loading
    @Published private(set) var networkState: NetworkState = .online

    private let moneyService: MoneyServiceProtocol
    private let repository: MoneyRepository
    private var cancellables = Set<AnyCancellable>()

    init(
        moneyService: MoneyServiceProtocol = MoneyService(),
        networkMonitor: NetworkMonitor = NetworkMonitorService(),
        repository: MoneyRepository = UserDefaultMoneyRepository()
    ) {
        self.moneyService = moneyService
        self.repository = repository
        configureLocalStorage(repository: repository)
        configureNetworkState(networkMonitor: networkMonitor, repository: repository)
    }

    func fetchData() async {
        // Perform API Requests in parallel
        await withTaskGroup(of: Void.self) { [weak self] group in
            guard let self else { return }
            group.addTask { await self.fetchAccountData() }
            group.addTask { await self.fetchTransactionsData() }

            await group.waitForAll()
        }
    }

    private func fetchAccountData() async {
        do {
            let account = try await moneyService.getAccount()
            accountBalance = .content(account.balanceFormatted)
            await repository.saveAccount(account)
        } catch {
            // TODO: some error handling
        }
    }

    private func fetchTransactionsData() async {
        do {
            let page = try await moneyService.getTransactions(page: 0, limit: Constants.pageSize)
            transactions = .content(page.transactions)
            await repository.saveTransactions(page)
        } catch {
            // TODO: some error handling
        }
    }

    private func configureNetworkState(networkMonitor: NetworkMonitor, repository: MoneyRepository) {
        networkMonitor.status
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .map {
                switch $0 {
                case .connected:    return .online
                case .disconnected: return .offline
                }
            }
            .assign(to: &$networkState)
    }

    private func configureLocalStorage(repository: MoneyRepository) {
        let fetchFromLocalStorage = $networkState
            .filter { $0 == .offline }
            .share()

        // Fetch account from local storage
        fetchFromLocalStorage
            .flatMap { _ in
                Future { promise in
                    Task {
                        promise(.success(await repository.getAccount()))
                    }
                }
            }
            .map { ViewState.content($0?.balanceFormatted ?? "-") }
            .assign(to: &$accountBalance)

        // Fetch transactions from local storage
        fetchFromLocalStorage
            .flatMap { _ in
                Future { promise in
                    Task {
                        promise(.success(await repository.getTransactions()))
                    }
                }
            }
            .map { ViewState.content($0?.transactions ?? []) }
            .assign(to: &$transactions)

        // Refresh data on when network comes back online
        $networkState
            .map { $0 == .online || $0 == .refreshing }
            .removeDuplicates()
            .dropFirst(1)
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.networkState = .refreshing
                Task {
                    await self?.fetchData()
                    self?.networkState = .online
                }
            }
            .store(in: &cancellables)

    }
}
