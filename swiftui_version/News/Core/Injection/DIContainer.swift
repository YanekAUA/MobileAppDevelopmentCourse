import Foundation

class DIContainer {
    static let shared = DIContainer()
    
    private var singletons: [String: Any] = [:]
    
    private init() {}
    
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        singletons[key] = factory()
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let instance = singletons[key] as? T else {
            fatalError("No instance registered for \(type)")
        }
        return instance
    }
}

// Setup dependencies
func setupDependencies() {
    let container = DIContainer.shared
    
    // Core
    container.register(NetworkClient.self) { NetworkClient.shared }
    container.register(ConnectivityManager.self) { ConnectivityManager.shared }
    
    // Data Sources
    container.register(NewsRemoteDataSource.self) {
        NewsRemoteDataSource(networkClient: container.resolve(NetworkClient.self))
    }
    
    // Repositories
    container.register(NewsRepository.self) {
        NewsRepositoryImpl(remoteDataSource: container.resolve(NewsRemoteDataSource.self))
    }
    
    // Use Cases
    container.register(GetTopHeadlinesUseCase.self) {
        GetTopHeadlinesUseCase(repository: container.resolve(NewsRepository.self))
    }
}
