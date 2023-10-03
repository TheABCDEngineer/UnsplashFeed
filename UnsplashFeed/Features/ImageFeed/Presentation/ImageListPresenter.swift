//
//  ImageListPresenter.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 04.07.2023.
//

import Foundation

class ImageListPresenter {
    private let photoFactory: PhotoFactoryProtocol
    private let favoritesRepository: FavoritesRepository
    private let photosObservable = ObservableData<[PhotoModel]>()
    private let errorStateObservable = ObservableData<AlertDialogModel>()
    
    init(
        photoFactory: PhotoFactoryProtocol,
        favoritesRepository: FavoritesRepository
    ) {
        self.photoFactory = photoFactory
        self.favoritesRepository = favoritesRepository
        
        photoFactory.setCallbacks(
            onSuccess: { photos in
                self.onPhotosSuccess(photos)
            },
            onFailure: { error in
                self.onPhotosFailure(with: error) {}
            }
        )
    }
    
    func setPhotosObserver(_ completion: @escaping ([PhotoModel]?) -> Void) {
        photosObservable.observe(completion)
    }
    
    func setErrorStateObserver(_ completion: @escaping (AlertDialogModel?) -> Void) {
        errorStateObservable.observe(completion)
    }
    
    func getPhotosNextPage() {
        photoFactory.getPhotosNextPage()
    }
    
    func changeLike(
        for photoModel: PhotoModel,
        _ completion: @escaping (PhotoModel) -> Void
    ) {
        guard let currentLike = photoModel.isLiked else { return }
        
        favoritesRepository.postFavoriteState(
            id: photoModel.id,
            isLike: !currentLike,
            onSuccess: { [weak self] responseLiked in
                guard let self else { return }
   
                if currentLike != responseLiked {
                    completion(
                        self.rebuildPhotoModel(model: photoModel, isLiked: responseLiked)
                    )
                } else {
                    completion(photoModel)
                    self.onChangeFavoriteStatusFailure(with: .urlSessionError) {}
                }
            },
            onFailure: { [weak self] error in
                guard let self else { return }
                self.onChangeFavoriteStatusFailure(with: error) {}
            }
        )
    }
    
    func rebuildPhotoModel(model: PhotoModel, isLiked: Bool?) -> PhotoModel {
        return PhotoModel(
            id: model.id,
            size: model.size,
            createdAt: model.createdAt,
            welcomeDescription: model.welcomeDescription,
            thumbImageURL: model.thumbImageURL,
            largeImageURL: model.largeImageURL,
            isLiked: isLiked
        )
    }
}

private extension ImageListPresenter {
    func onPhotosSuccess(_ photos: [PhotoModel]) {
        photosObservable.postValue(photos)
    }
    
    func onPhotosFailure(
        with error: NetworkError,
        _ callback: @escaping () -> Void
    ) {
        let errorAlertModel = AlertDialog.createDialogModel(
            title: "Не удаётся загрузить фотографии",
            message: getErrorDescription(from: error),
            applyTitle: "Ok",
            applyAction: { _ in
                callback()
            }
        )
        errorStateObservable.postValue(errorAlertModel)
    }
    
    func onChangeFavoriteStatusFailure(
        with error: NetworkError,
        _ callback: @escaping () -> Void
    ) {
        let errorAlertModel = AlertDialog.createDialogModel(
            title: "Не удаётся лайкнуть фотографию",
            message: getErrorDescription(from: error),
            applyTitle: "Ok",
            applyAction: { _ in
                callback()
            }
        )
        errorStateObservable.postValue(errorAlertModel)
    }
    
    func getErrorDescription(from error: NetworkError) -> String {
        switch error {
        case .tokenError(let description):
            return "Ошибка авторизации\n\(description)"
        case .urlError(let description):
            return "Внутренняя ошибка\n\(description)"
        case .urlRequestError(let error):
            return "Запрос выполнен с ошибкой\n\(error.localizedDescription)"
        case .urlSessionError:
            return "Ошибка сервера"
        case .httpStatusCode(let errorCode):
            return "Ошибка \(errorCode)"
        }
    }
}
