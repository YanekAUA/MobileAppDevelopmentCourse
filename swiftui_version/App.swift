import SwiftUI

@main
struct SwiftUINewsApp: App {
    init() {
        setupDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            NewsListView()
        }
    }
}
