import Foundation

final class PhotoFactory: PhotoFactoryProtocol {
    private let photoRepository: PhotoRepository
    private let tokenRepository: OAuth2TokenRepository
    private let perPage = 10
    private var page = 0
    private let queue = Queue<Int>()
    
    init(
        photosRepository: PhotoRepository,
        tokenRepository: OAuth2TokenRepository
    ) {
        self.photoRepository = photosRepository
        self.tokenRepository = tokenRepository
    }
    
    func getPhotosNextPage() {
        queue.add(page)
        page += 1
    }
    
    func setCallbacks(
        onSuccess: @escaping ([PhotoModel]) -> Void,
        onFailure: @escaping (NetworkError) -> Void
    ) {
        queue.setAction{ page in
            if page == nil { return }
            let token = self.tokenRepository.getToken()
            if token.isEmpty {
                onFailure(.tokenError("Token not found in storage"))
                return
            }
            self.photoRepository.fetchPhotosNextPage(
                page: page!,
                perPage: self.perPage,
                token: token,
                onSuccess: { photos in
                    onSuccess(photos)
                    self.queue.next()
                },
                onFailure: { error in
                    onFailure(error)
                    self.queue.next()
                }
            )
        }
    }
}
