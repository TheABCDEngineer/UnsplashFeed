import Foundation

protocol ProfileServiceProtocol {
    func fetchProfileProperties(
        token: String,
        completion: @escaping (Result<ProfilePropertiesModel, Error>) -> Void
    )
    
    func fetchProfileImageUrl(
        token: String,
        userName: String,
        imageSizeAttribute: String,
        completion: @escaping (Result<String?, Error>) -> Void
    )
}
