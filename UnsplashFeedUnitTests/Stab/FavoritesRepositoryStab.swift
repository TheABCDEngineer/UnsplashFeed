import Foundation
@testable import UnsplashFeed

final class FavoritesRepositoryStab: FavoritesRepository {
    func postFavoriteState(
        id: String,
        isLike: Bool,
        onSuccess: @escaping (Bool) -> Void,
        onFailure: @escaping (NetworkError) -> Void
    ) {
        onSuccess(isLike)
    }
}
