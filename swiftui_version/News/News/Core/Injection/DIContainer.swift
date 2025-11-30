import Foundation

/// Service locator / Dependency Injection container
class DIContainer {
    static let shared = DIContainer()
    
    private var services: [String: Any] = [:]
    
    private init() {}
    
    /// Register a singleton service
    func registerSingleton<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        services[key] = factory()
        AppLogger.d("DIContainer: Registered singleton for \(key)")
    }
    
    /// Register a lazy singleton service
    func registerLazySingleton<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        var instance: T?
        
        services[key] = {
            if instance == nil {
                instance = factory()
                AppLogger.d("DIContainer: Lazily initialized singleton for \(key)")
            }
            return instance!
        }
        
        AppLogger.d("DIContainer: Registered lazy singleton for \(key)")
    }
    
    /// Retrieve a registered service
    func resolve<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)
        
        if let factory = services[key] as? () -> T {
            return factory()
        }
        
        if let instance = services[key] as? T {
            return instance
        }
        
        AppLogger.w("DIContainer: No registration found for \(key)")
        return nil
    }
    
    /// Initialize the dependency container with all required services
    func initialize() {
        AppLogger.i("DIContainer: Initializing dependency container")
        
        // Core services
        registerSingleton(HttpClient.self) {
            HttpClient()
        }
        
        // Data sources
        registerLazySingleton(NewsRemoteDataSource.self) {
            NewsRemoteDataSource(httpClient: self.resolve(HttpClient.self)!)
        }
        
        // Repositories
        registerLazySingleton(NewsRepository.self) {
            NewsRepositoryImpl(remoteDataSource: self.resolve(NewsRemoteDataSource.self)!)
        }
        
        // Usecases
        registerLazySingleton(GetTopHeadlinesUseCase.self) {
            GetTopHeadlinesUseCase(repository: self.resolve(NewsRepository.self)!)
        }
        
        AppLogger.i("DIContainer: Initialization complete")
    }
}
