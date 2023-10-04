import Foundation

protocol ImageListPresenterProtocol {
    func setPhotosObserver(_ completion: @escaping ([PhotoModel]?) -> Void)
    func setErrorStateObserver(_ completion: @escaping (AlertDialogModel?) -> Void)
    func getPhotosNextPage()
    func changeLike(for photoModel: PhotoModel,_ completion: @escaping (PhotoModel) -> Void)
    func rebuildPhotoModel(model: PhotoModel, isLiked: Bool?) -> PhotoModel
}
