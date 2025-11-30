import Foundation

class AppLogger {
    static let shared = AppLogger()
    
    private init() {}
    
    func debug(_ message: String) {
        print("🔵 DEBUG: \(message)")
    }
    
    func info(_ message: String) {
        print("ℹ️ INFO: \(message)")
    }
    
    func warning(_ message: String) {
        print("⚠️ WARNING: \(message)")
    }
    
    func error(_ message: String) {
        print("❌ ERROR: \(message)")
    }
}
