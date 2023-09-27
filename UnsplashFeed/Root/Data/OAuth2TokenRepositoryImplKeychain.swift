import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenRepositoryImplKeychain: OAuth2TokenRepository {
    private let keychain = KeychainWrapper.standard
    private let tokenKey = "token"
    
    func getToken() -> String? {
        return keychain.string(forKey: tokenKey)
    }
    
    func putToken(_ token: String) {
        keychain.set(token, forKey: tokenKey)
    }
}
