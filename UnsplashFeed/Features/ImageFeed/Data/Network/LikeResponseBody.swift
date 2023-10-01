import Foundation

struct LikeResponseBody: Decodable {
    let isLiked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case isLiked = "liked_by_user"
    }
}
