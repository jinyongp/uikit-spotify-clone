import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

enum APIError: Error {
    case invalidUrl
    case unauthorized
}

final class APIService {
    static let shared = APIService()
    private init() {}

    private let logger = ConsoleLogger.shared
    private let decoder = JSONDecoder()

    private enum API_URL {
        static let baseUrl = "https://api.spotify.com/v1"
    }

    func fetch<T: Codable>(
        url: String, method: HttpMethod = .get,
        model: T.Type,
        success: @escaping (T) -> Void,
        failure: ((Error) -> Void)? = nil
    ) {
        _ = fetch(url: url, model: model, lazy: false, success: success, failure: failure)
    }

    @discardableResult
    func fetch<T: Codable>(
        url: String, method: HttpMethod = .get,
        model: T.Type,
        lazy: Bool = false,
        query: [(name: String, value: String)] = [],
        success: @escaping (T) -> Void,
        failure: ((Error) -> Void)? = nil
    ) -> () -> Void {
        func load() {
            Task {
                do {
                    guard var url = URL(string: API_URL.baseUrl + url) else { return failure?(APIError.invalidUrl) }
                    url.append(queries: query)
                    logger.info("URL: \(url.absoluteString)")
                    let request = try await createRequest(url: url)
                    let (data, _) = try await URLSession.shared.data(for: request)
                    let model = try decoder.decode(T.self, from: data)
                    success(model)
                } catch {
                    failure?(error)
                }
            }
        }

        if !lazy { load() }
        return load
    }

    private func createRequest(url: URL?, method: HttpMethod = .get) async throws -> URLRequest {
        guard let url else { throw APIError.invalidUrl }
        guard let token = await AuthService.shared.authToken else { throw APIError.unauthorized }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 30
        return request
    }
}
