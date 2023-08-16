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
        
    func provideAuthorization(
        code: String,
        completion: @escaping (Error?) -> Void
    ) {
        authService.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.tokenRepository.putToken(token)
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}
