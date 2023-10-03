import Foundation

protocol OAuth2TokenRepository {
    func getToken() -> String
    func putToken(_ token: String)
    func removeToken()
}
