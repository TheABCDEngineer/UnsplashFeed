import Foundation

final class Creator {
    
//MARK: - Presenters injections
    static func createProfilePresenter() -> ProfilePresenter {
        return ProfilePresenter(
            profileRepository: injectProfileRepository()
        )
    }
    
    static func createSplashViewPresenter() -> SplashViewPresenter {
        return SplashViewPresenter(
            profileLoader: injectProfileLoaderProtocol(),
            tokenRepository: injectOAuth2TokenRepository()
        )
    }
    
    static func createWebViewPresenter() -> WebViewPresenter {
        return WebViewPresenter()
    }
    
    static func createAuthViewPresenter() -> AuthViewPresenter {
        return AuthViewPresenter(
            authService: injectOAuth2ServiceProtocol(),
            tokenRepository: injectOAuth2TokenRepository()
        )
    }
}

//MARK: - Protocols injections
extension Creator {
    static func injectOAuth2TokenRepository() -> OAuth2TokenRepository {
        return OAuth2TokenRepositoryImplKeychain()
    }
    
    static func injectOAuth2ServiceProtocol() -> OAuth2ServiceProtocol {
        return OAuth2Service()
    }
    
    static func injectProfileRepository() -> ProfileRepository {
        return ProfileRepositoryImplSingleton.shared
    }
 
    static func injectProfileServiceProtocol() -> ProfileServiceProtocol{
        return ProfileService()
    }
    
    static func injectProfileLoaderProtocol() -> ProfileLoaderProtocol {
        if let profileLoaderSingleton = ProfileLoader.shared {
            return profileLoaderSingleton
        }
        let profileLoader = ProfileLoader(
                profileService: injectProfileServiceProtocol(),
                profileRepository: injectProfileRepository(),
                tokenRepository: injectOAuth2TokenRepository()
        )
        ProfileLoader.shared = profileLoader
        return ProfileLoader.shared!
    }
}

//MARK: - Notification Names
extension Creator {
    static let OnProfileAvatarUrlDidLoad = Notification.Name(rawValue: "OnProfileAvatarUrlDidLoad")
}
