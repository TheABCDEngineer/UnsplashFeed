import Foundation

protocol FavoritesRepository {
    func postFavoriteState(
        id: String,
        isLike: Bool,
        onSuccess: @escaping (Bool) -> Void,
        onFailure: @escaping (NetworkError) -> Void
    )
}
