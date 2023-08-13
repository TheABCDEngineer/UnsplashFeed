//
//  WebViewPresenter.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 13.08.2023.
//

import Foundation
import WebKit

final class WebViewPresenter {
    private struct WebAuthValue {
        static let code = "code"
        static let authPath = "/oauth/authorize/native"
    }
    
    func getWebUrl() -> URL {
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
           URLQueryItem(name: "client_id", value: AccessKey),
           URLQueryItem(name: "redirect_uri", value: RedirectURI),
           URLQueryItem(name: "response_type", value: WebAuthValue.code),
           URLQueryItem(name: "scope", value: AccessScope)
         ]
        return urlComponents.url!
    }
    
    func handleNavigationAction(
        url: URL?,
        completion: @escaping (String) -> Void
    ) -> WKNavigationActionPolicy {
        if let code = fetchCode(from: url) {
            completion(code)
            return .cancel
        } else {
            return .allow
        }
    }
    
    private func fetchCode(from url: URL?) -> String? {
        guard
            let url = url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == WebAuthValue.authPath,
            let codeItem = urlComponents.queryItems?.first(where: { $0.name == WebAuthValue.code })
        else { return nil }
            return codeItem.value
    }
}
