import Foundation
struct PhotoResponseBody: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let description: String?
    let isLiked: Bool?
    let urls: Dictionary<String,String>
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case isLiked = "liked_by_user"
        case urls
    }
}
