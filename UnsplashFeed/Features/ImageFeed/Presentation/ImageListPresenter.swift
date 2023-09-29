//
//  ImageListPresenter.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 04.07.2023.
//

import Foundation

class ImageListPresenter {
    private let photoFactory: PhotoFactoryProtocol
    private let photosObservable = ObservableData<[PhotoModel]>()
    private let errorStateObservable = ObservableData<AlertDialogModel>()
    
    init(photoFactory: PhotoFactoryProtocol) {
        self.photoFactory = photoFactory
        photoFactory.setCallbacks(
            onSuccess: { photos in
                self.onPhotosSuccess(photos)
            },
            onFailure: { error in
                self.onPhotosFailure(error)
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
}

private extension ImageListPresenter {
    func onPhotosSuccess(_ photos: [PhotoModel]) {
        photosObservable.postValue(photos)
    }
    
    func onPhotosFailure(_ error: NetworkError) {
        let errorAlertModel = AlertDialogModel(
            title: "Что-то пошло не так(",
            message: getErrorDescription(from: error),
            buttonTitle: "Ok",
            completion: { _ in}
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
