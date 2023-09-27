import Foundation

protocol OAuth2ServiceProtocol {
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    )
}
