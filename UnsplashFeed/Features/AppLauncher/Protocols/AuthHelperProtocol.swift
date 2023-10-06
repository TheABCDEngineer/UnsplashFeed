import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func authURL() -> URL?
    func code(from url: URL?) -> String?
}
