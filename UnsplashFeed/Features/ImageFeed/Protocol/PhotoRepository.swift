import Foundation
protocol PhotoRepository {
    func fetchPhotosNextPage(
        page: Int,
        perPage: Int,
        token: String,
        onSuccess: @escaping ([PhotoModel]) -> Void,
        onFailure: @escaping (NetworkError) -> Void
    )
}
