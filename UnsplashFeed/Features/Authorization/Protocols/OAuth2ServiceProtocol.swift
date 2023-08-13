import Foundation

protocol OAuth2ServiceProtocol {
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Error) -> Void
    )
}
