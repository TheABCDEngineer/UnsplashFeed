import Foundation
@testable import UnsplashFeed

final class TokenRepositoryStab: OAuth2TokenRepository {
    private var token = "stab_token"
    
    func getToken() -> String {
        return token
    }
    
    func putToken(_ token: String) {
        self.token = token
    }
    
    func removeToken() {
        token = ""
    }
    
    
}
