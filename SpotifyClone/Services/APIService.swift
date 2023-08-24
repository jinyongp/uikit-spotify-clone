import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

final class APIService {
    static let shared = APIService()
    private init() {}

    let logger = ConsoleLogger()
    
    var userProfile: UserProfile? {
        get async throws {
            guard let request = try await createRequest(url: URL(string: API_URL.baseUrl + "/me")) else { return nil }
            let (data, _) = try await URLSession.shared.data(for: request)
            let result = try JSONDecoder().decode(UserProfile.self, from: data)
            return result
        }
        
    }
    
    private struct API_URL {
        static let baseUrl = "https://api.spotify.com/v1"
    }

    
    
    private func createRequest(url: URL?, method: HttpMethod = .get) async throws -> URLRequest? {
        guard let url else { return nil }
        guard let token = await AuthService.shared.authToken else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 30
        return request
    }
}
