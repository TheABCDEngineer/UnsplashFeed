import Foundation

final class SplashViewPresenter {
    private let tokenRepository: OAuth2TokenRepository
    
    init(tokenRepository: OAuth2TokenRepository) {
        self.tokenRepository = tokenRepository
    }
    
    func getAuthorizationStatus() -> Bool {
        if let _ = tokenRepository.getToken() {
            return true
        }
        return false
    }
}
