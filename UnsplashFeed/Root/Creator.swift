import Foundation

final class Creator {
    static func createWebViewPresenter() -> WebViewPresenter {
        return WebViewPresenter()
    }
    
    static func createAuthViewPresenter() -> AuthViewPresenter {
        return AuthViewPresenter(
            authService: OAuth2Service(repository: Creator.createOAuth2TokenRepository()),
            tokenRepository: Creator.createOAuth2TokenRepository()
        )
    }
    
    static func createOAuth2TokenRepository() -> OAuth2TokenRepository {
        return OAuth2TokenRepositoryImplUserDefaults()
    }
}
