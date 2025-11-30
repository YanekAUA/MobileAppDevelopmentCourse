import SwiftUI

@main
struct NewsApp: App {
    init() {
        // Initialize dependency injection container on app start
        DIContainer.shared.initialize()
        AppLogger.i("NewsApp: Initializing application")
    }
    
    var body: some Scene {
        WindowGroup {
            let useCase = DIContainer.shared.resolve(GetTopHeadlinesUseCase.self)!
            NewsListView(getTopHeadlinesUseCase: useCase)
        }
    }
}
