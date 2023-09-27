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
    
    static func mapPhoto(dto: PhotoResponseBody) -> PhotoModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return PhotoModel(
            id: dto.id,
            size: CGSize(
                width: Double(dto.width),
                height: Double(dto.height)
            ),
            createdAt: dateFormatter.date(from: dto.createdAt),
            welcomeDescription: dto.description,
            thumbImageURL: dto.urls["thumb"],
            largeImageURL: dto.urls["full"],
            isLiked: dto.isLiked ?? false
        )
    }
    
    static func mapPhotos(dtoList: [PhotoResponseBody]) -> [PhotoModel] {
        var photoModels = [PhotoModel]()
        
        for photoDto in dtoList {
            photoModels.append(
                mapPhoto(dto: photoDto)
            )
        }
        return photoModels
    }
}
