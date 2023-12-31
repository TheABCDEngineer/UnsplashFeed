import Foundation

final class ProfileService: ProfileServiceProtocol {
    private let urlSessionService = URLSessionService()
    private let apiUrl = AuthConfiguration.standart.defaultBaseURL
    
    func fetchProfileProperties(
        token: String,
        completion: @escaping (Result<ProfilePropertiesModel, Error>) -> Void
    ) {
        urlSessionService.fetch(
            urlPath: "\(apiUrl)/me",
            httpMethod: "GET",
            header: "Bearer \(token)",
            headerField: "Authorization",
            responseBody: ProfilePropertiesResponseBody.self
        ) { (result: Result<ProfilePropertiesResponseBody, Error>) in
            switch result {
            case .success(let body):
                completion(.success(DataConverter.mapProfile(dto: body)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchProfileImageUrl(
        token: String,
        userName: String,
        imageSizeAttribute: String,
        completion: @escaping (Result<String?, Error>) -> Void
    ) {
        urlSessionService.fetch(
            urlPath: "\(apiUrl)/users/\(userName)",
            httpMethod: "GET",
            header: "Bearer \(token)",
            headerField: "Authorization",
            responseBody: ProfileImageResponseBody.self
        ) { (result: Result<ProfileImageResponseBody, Error>) in
            switch result {
            case .success(let body):
                completion(.success(body.profileImageUrl[imageSizeAttribute]))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
    
}
