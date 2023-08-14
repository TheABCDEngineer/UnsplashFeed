import Foundation

final class OAuth2TokenRepositoryImplUserDefaults: OAuth2TokenRepository {
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "token"
    
    func getToken() -> String {
        guard let token = userDefaults.string(forKey: tokenKey) else { return "" }
        return token
    }
    
    func putToken(_ token: String) {
        userDefaults.set(token, forKey: tokenKey)
    }
}
