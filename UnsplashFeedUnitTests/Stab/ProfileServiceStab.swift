import Foundation
@testable import UnsplashFeed

final class ProfileServiceStab: ProfileServiceProtocol {
    private let profilePropertiesResponse = ProfilePropertiesModel(
        userName: "testUserName",
        name: "testName",
        loginName: "testLoginName",
        bio: "testBio"
    )
    
    private let stringUrlResponse = "https://github.com/TheABCDEngineer"
    
    func fetchProfileProperties(
        token: String,
        completion: @escaping (Result<UnsplashFeed.ProfilePropertiesModel, Error>) -> Void
    ) {
        completion(.success(profilePropertiesResponse))
    }
    
    func fetchProfileImageUrl(
        token: String,
        userName: String,
        imageSizeAttribute: String,
        completion: @escaping (Result<String?, Error>) -> Void
    ) {
        completion(.success(stringUrlResponse))
    }
    
    
}
