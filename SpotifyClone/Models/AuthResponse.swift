import Foundation

struct AuthResponse {
    let tokenType: String
    let expiresIn: Int
    let accessToken: String
    let refreshToken: String?
}

extension AuthResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
