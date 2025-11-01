//
//  NetworkMonitor.swift
//  CookShare
//
//  Created by Olga Dragon on 21.10.2025.
//

import Network
import Combine

protocol NetworkMonitoring: AnyObject {
    var isConnected: Bool { get }
    var isConnectedPublisher: Published<Bool>.Publisher { get }
}

@MainActor
final class NetworkMonitor: ObservableObject, NetworkMonitoring {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    @Published private(set) var isConnected: Bool = true
    
    var isConnectedPublisher: Published<Bool>.Publisher { $isConnected }
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = (path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }
    
    func setConnectionForTests(_ connected: Bool) {
        self.isConnected = connected
    }
}
