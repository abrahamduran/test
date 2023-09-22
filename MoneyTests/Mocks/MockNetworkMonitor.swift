//
//  MockNetworkMonitor.swift
//  MoneyTests
//
//  Created by Abraham Duran on 9/22/23.
//

import Foundation
import Combine
@testable import Money

final class MockNetworkMonitor: NetworkMonitor {
    var subject = PassthroughSubject<NetworkStatus, Never>()
    lazy var status: AnyPublisher<NetworkStatus, Never> = subject.eraseToAnyPublisher()
}
