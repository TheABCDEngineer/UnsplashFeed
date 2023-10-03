import Foundation

final class FavoritesRepositoryImplNetwork: FavoritesRepository {
    private let tokenRepository: OAuth2TokenRepository
    private let urlSessionServiсe = URLSessionService()
    
    init(
        tokenRepository: OAuth2TokenRepository
    ) {
        self.tokenRepository = tokenRepository
    }
    
    func postFavoriteState(
        id: String,
        isLike: Bool,
        onSuccess: @escaping (Bool) -> Void,
        onFailure: @escaping (NetworkError) -> Void
    ) {
        let httpMethod = isLike ? HttpMethod.POST : HttpMethod.DELETE
        let token = self.tokenRepository.getToken()
        if token.isEmpty {
            onFailure(.tokenError("Token not found in storage"))
            return
        }
        urlSessionServiсe.fetch(
            urlPath: "\(UnsplashApiParameters.BaseApiURL)/photos/\(id)/like",
            httpMethod: httpMethod,
            header: "Bearer \(token)",
            headerField: "Authorization",
            responseBody: FavoritePhotoResponseBody.self
        ) { (result: Result<FavoritePhotoResponseBody, Error>) in
            switch result {
            case .success(let body):
                guard let isLiked = body.photo.isLiked else {
                    onFailure(.urlSessionError)
                    return
                }
                onSuccess(isLiked)
            case .failure(let error):
                onFailure(.urlRequestError(error))
            }
        }
    }
}
