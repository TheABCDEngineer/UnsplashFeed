import Foundation

final class Creator {
    static func createSplashViewPresenter() -> SplashViewPresenter {
        return SplashViewPresenter(tokenRepository: createOAuth2TokenRepository())
    }
    
    static func createWebViewPresenter() -> WebViewPresenter {
        return WebViewPresenter()
    }
    
    static func createAuthViewPresenter() -> AuthViewPresenter {
        return AuthViewPresenter(
            authService: OAuth2Service(),
            tokenRepository: createOAuth2TokenRepository()
        )
    }
    
    static func createOAuth2TokenRepository() -> OAuth2TokenRepository {
        return OAuth2TokenRepositoryImplUserDefaults()
    }
}
