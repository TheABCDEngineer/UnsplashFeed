import Foundation

final class AuthViewPresenter {
    private let authService: OAuth2ServiceProtocol
    private let tokenRepository: OAuth2TokenRepository
    init(
        authService: OAuth2ServiceProtocol,
        tokenRepository: OAuth2TokenRepository
    ) {
        self.authService = authService
        self.tokenRepository = tokenRepository
    }
    
    func getAuthorizationStatus() -> Bool {
        print("getAuthorizationStatus")
        let token = tokenRepository.getToken()
        if token.isEmpty {
            print("false")
            return false }
        return true
    }
    
    func provideAuthorization(code: String) -> Error? {
        var error: Error?
        authService.fetchOAuthToken(code) { _error in
            error = _error
        }
        return error
    }
}
