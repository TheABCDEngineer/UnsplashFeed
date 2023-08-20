import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenRepositoryImplKeychain: OAuth2TokenRepository {
    private let keychain = KeychainWrapper.standard
    private let tokenKey = "token"
    
    func getToken() -> String {
        guard let token = keychain.string(forKey: tokenKey) else { return "" }
        return token
    }
    
    func putToken(_ token: String) {
        keychain.set(token, forKey: tokenKey)
    }
}
