import Foundation

final class DataConverter {
    static func mapProfile (dto: ProfilePropertiesResponseBody) -> ProfilePropertiesModel {
        return ProfilePropertiesModel(
            userName: dto.username,
            name: "\(dto.firstName) \(dto.lastName)",
            loginName: "@\(dto.username)",
            bio: dto.bio)
    }
}
