//
//  OAuth2Service.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 13.08.2023.
//

import Foundation

final class OAuth2Service: OAuth2ServiceProtocol {
    private let urlSessionService = URLSessionService()
    private let baseURL = "https://unsplash.com"
 
    func fetchOAuthToken(
            _ code: String,
            completion: @escaping (Result<String, Error>) -> Void
    ) {
        urlSessionService.fetch(
            urlPath: createOAuthPath(code: code),
            httpMethod: "POST",
            responseBody: OAuthResponseBody.self
        ) { (result: Result<OAuthResponseBody, Error>) in
            switch result {
            case .success(let body):
                completion(.success(body.accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func createOAuthPath(code: String) -> String {
        return "https://unsplash.com/oauth/token"
            + "?client_id=\(UnsplashApiParameters.AccessKey)"
            + "&&client_secret=\(UnsplashApiParameters.SecretKey)"
            + "&&redirect_uri=\(UnsplashApiParameters.RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code"
        }
}
