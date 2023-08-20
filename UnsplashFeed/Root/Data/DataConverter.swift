import Foundation

final class DataConverter {
    static func mapProfile (dto: ProfilePropertiesResponseBody) -> ProfilePropertiesModel {
        return ProfilePropertiesModel(
            userName: dto.username,
            name: "\(dto.firstName) \(dto.lastName)",
            loginName: "@\(dto.username)",
            bio: dto.bio)
    }
    
    static func swapToProfileModel(
        _ avatarStringUrl: String?,
        _ profileProperties: ProfilePropertiesModel
    ) -> ProfileModel {
        var url: URL? = nil
        if let stringUrl = avatarStringUrl {
            url = URL(string: stringUrl)
        }
        return ProfileModel(
            avatarUrl: url,
            userName: profileProperties.userName,
            name: profileProperties.name,
            loginName: profileProperties.loginName,
            bio: profileProperties.bio
        )
    }
}
