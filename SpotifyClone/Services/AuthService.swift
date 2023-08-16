import Foundation

final class AuthService {
    static let shared = AuthService()
    private init() {}
    
    var isAuthenticated: Bool { return false }
    
    private var accessToken: String? { return nil }
    
    private var refreshToken: String? { return nil }
    
    
}
