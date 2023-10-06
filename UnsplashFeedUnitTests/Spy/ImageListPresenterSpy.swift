import Foundation
@testable import UnsplashFeed

final class ImageListPresenterSpy: ImageListPresenterProtocol {
    var photoObserverDidSet = false
    var errorStateObserverDidSet = false
    var getPhotosNextPageOnViewDidLoad = false
    
    func setPhotosObserver(_ completion: @escaping ([PhotoModel]?) -> Void) {
        photoObserverDidSet = true
    }
    
    func setErrorStateObserver(_ completion: @escaping (AlertDialogModel?) -> Void) {
        errorStateObserverDidSet = true
    }
    
    func getPhotosNextPage() {
        getPhotosNextPageOnViewDidLoad = true
    }
    
    func changeLike(for photoModel: PhotoModel, _ completion: @escaping (PhotoModel) -> Void) {
    }
    
    func rebuildPhotoModel(model: PhotoModel, isLiked: Bool?) -> PhotoModel {
        return PhotoModel(id: "", size: CGSize(width: 0, height: 0), createdAt: nil, welcomeDescription: nil, thumbImageURL: nil, largeImageURL: nil, isLiked: nil)
    }
}
