import Foundation

class EnvConfig {
    static let shared = EnvConfig()
    
    private var envVariables: [String: String] = [:]
    
    private init() {
        loadEnvFile()
    }
    
    private func loadEnvFile() {
        guard let envPath = Bundle.main.path(forResource: ".env", ofType: "") else {
            AppLogger.shared.warning("WARNING: .env file not found. Create a .env file and add NEWS_API_KEY to use the News API.")
            return
        }
        
        do {
            let envContent = try String(contentsOfFile: envPath, encoding: .utf8)
            for line in envContent.split(separator: "\n") {
                let trimmed = String(line).trimmingCharacters(in: .whitespaces)
                if trimmed.isEmpty || trimmed.starts(with: "#") {
                    continue
                }
                let parts = trimmed.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
                if parts.count == 2 {
                    let key = String(parts[0]).trimmingCharacters(in: .whitespaces)
                    let value = String(parts[1]).trimmingCharacters(in: .whitespaces)
                    envVariables[key] = value
                }
            }
        } catch {
            AppLogger.shared.error("Failed to load .env file: \(error.localizedDescription)")
        }
    }
    
    var newsApiKey: String {
        envVariables["NEWS_API_KEY"] ?? ""
    }
    
    var newsBaseUrl: String {
        envVariables["NEWS_BASE_URL"] ?? "https://newsapi.org/v2"
    }
}
