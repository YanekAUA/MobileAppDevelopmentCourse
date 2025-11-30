import Foundation
import os.log

/// Centralized logging utility for the application
class AppLogger {
    private static let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "News", category: "App")
    
    enum LogLevel {
        case debug
        case info
        case warning
        case error
    }
    
    static func log(_ message: String, level: LogLevel = .debug) {
        switch level {
        case .debug:
            logger.debug("\(message)")
        case .info:
            logger.info("\(message)")
        case .warning:
            logger.warning("\(message)")
        case .error:
            logger.error("\(message)")
        }
    }
    
    static func d(_ message: String) {
        log(message, level: .debug)
    }
    
    static func i(_ message: String) {
        log(message, level: .info)
    }
    
    static func w(_ message: String) {
        log(message, level: .warning)
    }
    
    static func e(_ message: String) {
        log(message, level: .error)
    }
}
