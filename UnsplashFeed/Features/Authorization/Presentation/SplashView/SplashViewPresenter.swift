import Foundation

final class SplashViewPresenter {
    private let tokenRepository: OAuth2TokenRepository
    
    init(tokenRepository: OAuth2TokenRepository) {
        self.tokenRepository = tokenRepository
    }
    
    func getAuthorizationStatus() -> Bool {
        let token = tokenRepository.getToken()
        if token.isEmpty { return false }
        return true
    }
}
