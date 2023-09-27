import Foundation

final class ProfileRepositoryImplSingleton: ProfileRepository {
    static let shared = ProfileRepositoryImplSingleton()
    private(set) var properties: ProfilePropertiesModel?
    private(set) var avatarUrl: URL?
    
    func saveProfileProperties(_ model: ProfilePropertiesModel) {
        self.properties = model
    }
    
    func saveProfileAvatarUrl(_ url: URL?) {
        self.avatarUrl = url
    }
}
