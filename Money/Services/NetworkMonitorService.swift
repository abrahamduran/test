//
//  NetworkMonitorService.swift
//  Money
//
//  Created by Abraham Duran on 9/21/23.
//

import Foundation
import Combine
import Network

protocol NetworkMonitor {
    var status: AnyPublisher<NetworkStatus, Never> { get }
}

enum NetworkStatus {
    case connected, disconnected
}

final class NetworkMonitorService: NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorService")
    private let subject = CurrentValueSubject<NetworkStatus, Never>(.connected)

    lazy var status = subject.eraseToAnyPublisher()

    init() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.subject.send(.connected)
            } else {
                self.subject.send(.disconnected)
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        subject.send(completion: .finished)
        monitor.cancel()
    }
}
