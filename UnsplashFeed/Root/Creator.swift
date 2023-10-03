import Foundation
import WebKit

final class Creator {
    
//MARK: - Presenters injections
    static func createProfilePresenter() -> ProfilePresenter {
        return ProfilePresenter(
            profileRepository: injectProfileRepository(),
            tokenRepository: injectOAuth2TokenRepository()
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
    
    static func createImageListPresenter() -> ImageListPresenter {
        return ImageListPresenter(
            photoFactory: injectPhotoFactoryProtocol(),
            favoritesRepository: injectFavoritesRepository()
        )
    }
}

//MARK: - Repositories injections
extension Creator {
    static func injectOAuth2TokenRepository() -> OAuth2TokenRepository {
        return OAuth2TokenRepositoryImplKeychain()
    }
    
    static func injectProfileRepository() -> ProfileRepository {
        return ProfileRepositoryImplSingleton.shared
    }
    
    static func injectPhotoRepository() -> PhotoRepository {
        return PhotoRepositoryImplNetwork()
    }
    
    static func injectFavoritesRepository() -> FavoritesRepository {
        return FavoritesRepositoryImplNetwork(
            tokenRepository: injectOAuth2TokenRepository()
        )
    }
}

//MARK: - Protocols injections
extension Creator {
    static func injectOAuth2ServiceProtocol() -> OAuth2ServiceProtocol {
        return OAuth2Service()
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
    
    static func injectPhotoFactoryProtocol() -> PhotoFactoryProtocol {
        return PhotoFactory(
            photosRepository: injectPhotoRepository(),
            tokenRepository: injectOAuth2TokenRepository()
        )
    }
}

//MARK: - Notification Names
extension Creator {
    static let OnProfileAvatarUrlDidLoad = Notification.Name(rawValue: "OnProfileAvatarUrlDidLoad")
}

//MARK: - Clean Cookies
extension Creator {
    static func cleanWebCookies() {
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
       WKWebsiteDataStore.default().fetchDataRecords(
        ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()
       ) { records in
          records.forEach { record in
             WKWebsiteDataStore.default().removeData(
                ofTypes: record.dataTypes,
                for: [record],
                completionHandler: {}
             )
          }
       }
    }
}
