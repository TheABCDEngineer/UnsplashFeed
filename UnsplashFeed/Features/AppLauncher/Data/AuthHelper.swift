import Foundation

final class AuthHelper: AuthHelperProtocol {
    private let configuration = AuthConfiguration.standart
    private struct WebAuthValue {
        static let code = "code"
        static let authPath = "/oauth/authorize/native"
    }
    
    func authRequest() -> URLRequest? {
        var urlComponents = URLComponents(string: configuration.authURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: WebAuthValue.code),
            URLQueryItem(name: "scope", value: configuration.accessScope)
         ]
        guard let url = urlComponents.url else { return nil }
        return URLRequest(url: url)
    }
    
    func code(from url: URL?) -> String? {
        guard
            let url = url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == WebAuthValue.authPath,
            let codeItem = urlComponents.queryItems?.first(where: { $0.name == WebAuthValue.code })
        else { return nil }
            return codeItem.value
    }
    
    
}
