import Foundation

/// Environment configuration loader for API keys and endpoints
struct EnvConfig {
    /// Reads configuration from Info.plist
    static var newsApiKey: String {
        guard let key = Bundle.main.infoDictionary?["NEWS_API_KEY"] as? String else {
            AppLogger.w("WARNING: NEWS_API_KEY is not set in Info.plist. Add NEWS_API_KEY to use the News API.")
            return ""
        }
        return key
    }
    
    static var newsBaseUrl: String {
        guard let url = Bundle.main.infoDictionary?["NEWS_BASE_URL"] as? String else {
            return "https://newsapi.org/v2"
        }
        return url
    }
}
