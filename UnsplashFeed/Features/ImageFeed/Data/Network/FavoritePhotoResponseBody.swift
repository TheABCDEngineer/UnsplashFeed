import Foundation

struct FavoritePhotoResponseBody: Decodable {
    let photo: LikeResponseBody
    
    enum CodingKeys: String, CodingKey {
        case photo
    }
}
