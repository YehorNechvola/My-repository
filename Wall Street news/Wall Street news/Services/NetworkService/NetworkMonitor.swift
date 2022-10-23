

import Foundation
import Network

//MARK: - NetworkMonitorProtocol

protocol NetworkMonitorProtocol {
    func startMonitoring()
}

class NetworkMonitor: NetworkMonitorProtocol {
    
    //MARK: - Properties
    
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global(qos: .userInteractive)
    private let monitor = NWPathMonitor()
    private(set) var isConnected = false
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
}
