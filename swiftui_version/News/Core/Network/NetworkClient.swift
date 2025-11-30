import Foundation

class NetworkClient {
    static let shared = NetworkClient()
    
    private let session: URLSession
    private let baseURL: String
    private let apiKey: String
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        config.waitsForConnectivity = true
        
        self.session = URLSession(configuration: config)
        self.baseURL = EnvConfig.shared.newsBaseUrl
        self.apiKey = EnvConfig.shared.newsApiKey
    }
    
    func get<T: Decodable>(
        endpoint: String,
        queryParameters: [String: String] = [:]
    ) async throws -> T {
        var components = URLComponents(string: "\(baseURL)\(endpoint)")
        
        var queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        if !apiKey.isEmpty {
            queryItems.append(URLQueryItem(name: "apiKey", value: apiKey))
        }
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        AppLogger.shared.debug("GET request to: \(url.absoluteString)")
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            AppLogger.shared.error("HTTP Error: \(httpResponse.statusCode)")
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            AppLogger.shared.error("Decoding error: \(error.localizedDescription)")
            throw NetworkError.decodingError
        }
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP Error: \(statusCode)"
        case .decodingError:
            return "Failed to decode response"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}
