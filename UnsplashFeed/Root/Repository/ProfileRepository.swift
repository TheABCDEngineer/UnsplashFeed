import Foundation

protocol ProfileRepository {
    var properties: ProfilePropertiesModel? { get }
    var avatarUrl: URL? { get }
    func saveProfileProperties(_ model: ProfilePropertiesModel)
    func saveProfileAvatarUrl(_ url: URL?)
}
