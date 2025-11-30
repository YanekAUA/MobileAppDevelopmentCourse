import Foundation

/// Custom error types for network operations
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(statusCode: Int)
    case networkError(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Server error: \(statusCode)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}

/// URLSession-based HTTP client with API key injection
class HttpClient {
    private let session: URLSession
    private let baseURL: URL
    private let apiKey: String
    
    init(baseURL: String = EnvConfig.newsBaseUrl, apiKey: String = EnvConfig.newsApiKey) {
        self.session = URLSession.shared
        self.apiKey = apiKey
        
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid base URL: \(baseURL)")
        }
        self.baseURL = url
    }
    
    /// Performs a GET request with query parameters
    func get<T: Decodable>(endpoint: String, queryParameters: [String: String]? = nil) async throws -> T {
        var url = baseURL.appendingPathComponent(endpoint)
        
        // Add API key and custom query parameters
        var queryItems = [URLQueryItem(name: "apiKey", value: apiKey)]
        if let params = queryParameters {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        
        guard let finalURL = components?.url else {
            AppLogger.e("Invalid URL construction for endpoint: \(endpoint)")
            throw NetworkError.invalidURL
        }
        
        AppLogger.d("HttpClient: GET \(finalURL.absoluteString)")
        
        do {
            let (data, response) = try await session.data(from: finalURL)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                AppLogger.e("HttpClient: Invalid response type")
                throw NetworkError.invalidResponse
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                AppLogger.e("HttpClient: Server error - status code \(httpResponse.statusCode)")
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decodedResponse = try decoder.decode(T.self, from: data)
                AppLogger.d("HttpClient: Successfully decoded response for endpoint: \(endpoint)")
                return decodedResponse
            } catch {
                AppLogger.e("HttpClient: Decoding error - \(error.localizedDescription)")
                throw NetworkError.decodingError(error)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            AppLogger.e("HttpClient: Network error - \(error.localizedDescription)")
            throw NetworkError.networkError(error)
        }
    }
}
