import Foundation

final class DataConverter {
    static func mapProfile (dto: ProfilePropertiesResponseBody) -> ProfilePropertiesModel {
        var lastName: String {dto.lastName ?? ""}
        
        return ProfilePropertiesModel(
            userName: dto.username,
            name: "\(dto.firstName) \(lastName)",
            loginName: "@\(dto.username)",
            bio: dto.bio
        )
    }
}
