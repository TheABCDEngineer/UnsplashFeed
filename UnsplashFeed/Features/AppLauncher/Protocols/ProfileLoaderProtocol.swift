import Foundation

protocol ProfileLoaderProtocol {
    func loadProfileInformation(
        completion: @escaping (Result<ProfilePropertiesModel, Error>) -> Void
    )
    
    func loadProfileImageUrl(
        profile: ProfilePropertiesModel,
        completion: @escaping (Result<URL?, Error>) -> Void
    )
}
