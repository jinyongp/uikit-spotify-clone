import Foundation

final class AuthService {
    static let shared = AuthService()
    private init() {}

    private let storage = UserDefaults.standard
    private let logger = ConsoleLogger.shared

    private struct API_URL {
        static let endpoint = "https://accounts.spotify.com"
        static let authorize = "\(endpoint)/authorize"
        static let token = "\(endpoint)/api/token"
        static let redirect = "https://jinyongp.dev"
    }

    private struct Client {
        static let id = "948cbfe873ce4e15abd7f0115f05a338"
        static let secret = "e2f331d6160741d3ac03dc8bd2ba09a1"
    }

    private struct StorageKey {
        static let accessToken = "access_token"
        static let refreshToken = "refresh_token"
        static let expirationDate = "expiration_date"
    }

    let url: URL = {
        var url = URL(string: API_URL.authorize)!
        let scopes = [
            "user-read-email",
            "user-read-private",
            "user-library-read",
            "user-library-modify",
            "user-follow-read",

            "playlist-read-private",
            "playlist-modify-public",
            "playlist-modify-private",
        ]
        url.append(queries: [
            ("response_type", "code"),
            ("client_id", Client.id),
            ("scope", scopes.joined(separator: " ")),
            ("redirect_uri", API_URL.redirect),
            ("state", String.random(length: 16)),
            ("show_dialog", "true"),
        ])
        return url
    }()

    var authToken: String? {
        get async {
            if isExpired { try? await _refresh() }
            guard let accessToken else { return nil }
            return accessToken
        }
    }

    private var accessToken: String? { storage.string(forKey: StorageKey.accessToken) }
    private var refreshToken: String? { storage.string(forKey: StorageKey.refreshToken) }
    private var expirationDate: Date? { storage.object(forKey: StorageKey.expirationDate) as? Date }
    private var isExpired: Bool {
        guard let expirationDate else { return true }
        return Date().addingTimeInterval(.init(2 * 60)) >= expirationDate
    }

    private let authorizationToken: String? = {
        let data = (Client.id + ":" + Client.secret).data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else { return nil }
        return "Basic \(base64String)"
    }()

    func isAuthenticated() async -> Bool {
        guard isExpired else { return true }
        logger.info("AccessToken is \(expirationDate != nil ? "expired at \(expirationDate!)." : "not initialized.") ")

        guard let refreshToken else { return false }
        logger.info("Trying to refresh token...")

        guard let _ = try? await _refresh(token: refreshToken) else { return false }
        logger.info("AccessToken is refreshed successfully!")

        return true
    }

    func initializeTokens(code: String) async throws {
        let url = URL(string: API_URL.token, queries: [
            ("code", code),
            ("grant_type", "authorization_code"),
            ("redirect_uri", API_URL.redirect),
        ])!

        let request = {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(authorizationToken, forHTTPHeaderField: "Authorization")
            request.httpBody = url.query?.data(using: .utf8)
            return request
        }()

        async let (data, _) = URLSession.shared.data(for: request)
        let response = try await JSONDecoder().decode(AuthResponse.self, from: data)
        logger.info([
            "Tokens are Initialized:",
            "\tAccessToken: \(response.accessToken)",
            "\tRefreshToken: \(response.refreshToken ?? "None")",
        ].joined(separator: "\n"))
        _cache(response: response)
    }

    func startRefreshAccessToken() {
        guard refreshToken != nil else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 60 * 30) { [weak self] in
            Task {
                try? await self?._refresh()
                self?.startRefreshAccessToken()
            }
        }
    }

    private func _refresh(token: String? = nil) async throws {
        guard let token = token ?? refreshToken else { return }

        let url = URL(string: API_URL.token, queries: [
            ("grant_type", "refresh_token"),
            ("refresh_token", token),
        ])!

        let request = {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue(authorizationToken, forHTTPHeaderField: "Authorization")
            request.httpBody = url.query?.data(using: .utf8)
            return request
        }()

        async let (data, _) = URLSession.shared.data(for: request)
        let response = try await JSONDecoder().decode(AuthResponse.self, from: data)
        logger.info([
            "AccessToken is refreshed:",
            "\tAccessToken: \(response.accessToken)",
            "\tRefreshToken: \(response.refreshToken ?? "None")",
        ].joined(separator: "\n"))
        _cache(response: response)
    }

    private func _cache(response: AuthResponse) {
        UserDefaults.standard.setValue(response.accessToken, forKey: StorageKey.accessToken)
        if let refreshToken = response.refreshToken {
            UserDefaults.standard.setValue(refreshToken, forKey: StorageKey.refreshToken)
        }

        let expirationData = Date().addingTimeInterval(.init(response.expiresIn))
        UserDefaults.standard.setValue(expirationData, forKey: StorageKey.expirationDate)
    }
}
