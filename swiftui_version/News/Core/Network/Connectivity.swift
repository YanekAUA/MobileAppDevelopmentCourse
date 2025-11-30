import Foundation
import Network

class ConnectivityManager {
    static let shared = ConnectivityManager()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.news.connectivity")
    private(set) var isConnected = true
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    func hasInternetConnection() -> Bool {
        return isConnected
    }
}
