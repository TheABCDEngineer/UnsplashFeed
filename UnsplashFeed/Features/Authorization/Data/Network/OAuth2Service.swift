//
//  OAuth2Service.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 13.08.2023.
//

import Foundation

final class OAuth2Service: OAuth2ServiceProtocol {
    init(repository: OAuth2TokenRepository) {
        self.repository = repository
    }
    private let repository: OAuth2TokenRepository
    private struct AuthProperties {
        static let httpMethodPost = "POST"
        static let baseURL = URL(string: "https://unsplash.com")!
    }
    
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Error) -> Void
    ){
        let task = provideSessionTask(for: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                self.repository.putToken(body.accessToken)
            case .failure(let error):
                completion(error)
            }
        }
        task.resume()
    }
    
    private func createOAuthPath(code: String) -> String {
        return "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code"
    }
    
    private func provideSessionTask(
        for code: String,
        completion: @escaping (Result<OAuthResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let request = URLRequest.makeHTTPRequest(
            path: createOAuthPath(code: code),
            httpMethod: AuthProperties.httpMethodPost,
            baseURL: AuthProperties.baseURL
        )
        let decoder = JSONDecoder()
        return URLSession.shared.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthResponseBody, Error> in
                Result { try decoder.decode(OAuthResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
}
