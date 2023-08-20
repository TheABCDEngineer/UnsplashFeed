import Foundation

struct ProfileImageResponseBody: Decodable {
    let profileImageUrl: Dictionary<String,String>
    
    enum CodingKeys: String, CodingKey {
        case profileImageUrl = "profile_image"
    }
}
