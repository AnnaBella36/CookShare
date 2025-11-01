//
//  FakeNetworkMonitor.swift
//  CookShareHomeTests
//
//  Created by Olga Dragon on 01.11.2025.
//

import Foundation
import Combine
@testable import CookShare

@MainActor
final class FakeNetworkMonitor: NetworkMonitoring {
    @Published private(set) var isConnected: Bool
    var isConnectedPublisher: Published<Bool>.Publisher { $isConnected }
    
    init(isConnected: Bool) {
        self.isConnected = isConnected
    }
}
