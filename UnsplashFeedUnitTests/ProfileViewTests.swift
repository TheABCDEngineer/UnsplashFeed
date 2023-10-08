import Foundation
import XCTest
@testable import UnsplashFeed

final class ProfileViewTests: XCTestCase {
    func testGetProfile() throws {
        //given
        var profileLoader: ProfileLoaderProtocol? = ProfileLoader(
            profileService: ProfileServiceStab(),
            profileRepository: ProfileRepositoryImplSingleton.shared,
            tokenRepository: TokenRepositoryStab()
        )
        //when
        profileLoader?.loadProfileInformation{_ in}
        profileLoader?.loadProfileImageUrl(
            profile: ProfilePropertiesModel(userName: "", name: "", loginName: "", bio: "")
        ) {_ in}
        
        profileLoader = nil
        
        
        let presenter: ProfilePresenterProtocol = ProfilePresenter(
            profileRepository: ProfileRepositoryImplSingleton.shared,
            tokenRepository: TokenRepositoryStab()
        )
        
        let profile = presenter.getProfileInformation()
        var avatarUrl: URL?
        presenter.provideProfileAvatar{ url in
            avatarUrl = url
        }
        //then
        XCTAssertEqual(profile.userName, "testUserName")
        XCTAssertEqual(profile.name, "testName")
        XCTAssertEqual(profile.loginName, "testLoginName")
        XCTAssertEqual(profile.bio, "testBio")
        XCTAssertEqual(avatarUrl, URL(string: "https://github.com/TheABCDEngineer"))
    }
    
    func testProvideProfileAvatarOnNotification() throws {
        //given
        let profileRepository: ProfileRepository = ProfileRepositoryImplSingleton.shared
        let testStringUrl = "https://github.com/TheABCDEngineer"
    
        let presenter: ProfilePresenterProtocol = ProfilePresenter(
            profileRepository: profileRepository,
            tokenRepository: TokenRepositoryStab()
        )
        
        //when
        var avatarUrl: URL?
        presenter.provideProfileAvatar{ url in
            avatarUrl = url
        }
        
        profileRepository.saveProfileAvatarUrl(URL(string: testStringUrl))
        
        NotificationCenter
            .default
            .post(name: Creator.OnProfileAvatarUrlDidLoad, object: self)
        
        //then
        XCTAssertEqual(avatarUrl, URL(string: testStringUrl))
    }
    
    func testProfileLogout() throws {
        //given
        var profileViewControllerDidChangeToSplashViewController = false
        
        let tokenRepository: OAuth2TokenRepository = TokenRepositoryStab()
        tokenRepository.putToken("Some_token")
        XCTAssertFalse(tokenRepository.getToken().isEmpty)
        
        var cookieProperties = [HTTPCookiePropertyKey:Any]()
            cookieProperties[HTTPCookiePropertyKey.name] = "test"
            cookieProperties[HTTPCookiePropertyKey.value] = "test"
            cookieProperties[HTTPCookiePropertyKey.path] = "test"
            cookieProperties[HTTPCookiePropertyKey.domain] = ".example.com"

        let cookie = HTTPCookie(properties: cookieProperties)!
        HTTPCookieStorage.shared.setCookie(cookie)
        XCTAssertNotEqual(HTTPCookieStorage.shared.cookies, [])
        
        let profilePresenter: ProfilePresenterProtocol = ProfilePresenter(
            profileRepository: ProfileRepositoryImplSingleton.shared,
            tokenRepository: tokenRepository
        )
        
        //when
        let logoutDialogModel = profilePresenter.onProfileLogout {
            profileViewControllerDidChangeToSplashViewController = true
        }
        logoutDialogModel.applyAction(UIAlertAction(title: "test", style: .default))
        
        //then
        XCTAssertTrue(profileViewControllerDidChangeToSplashViewController)
        XCTAssertTrue(tokenRepository.getToken().isEmpty)
        XCTAssertEqual(HTTPCookieStorage.shared.cookies, [])
    }
}
