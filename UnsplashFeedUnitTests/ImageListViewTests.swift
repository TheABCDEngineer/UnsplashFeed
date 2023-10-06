import Foundation
import XCTest
@testable import UnsplashFeed

final class ImageListViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() throws {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as? ImageListViewController else {
            fatalError("Can't find ImageListViewController")
        }
        let presenter = ImageListPresenterSpy()
        viewController.presenter = presenter
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.photoObserverDidSet)
        XCTAssertTrue(presenter.errorStateObserverDidSet)
        XCTAssertTrue(presenter.getPhotosNextPageOnViewDidLoad)
    }
    
    func testPhotosDidLoadOnRequest() throws {
        //given
        let photoFactory = PhotoFactory(
            photosRepository: PhotoRepositoryStab(),
            tokenRepository: TokenRepositoryStab()
        )
        let imageListPresenter = ImageListPresenter(
            photoFactory: photoFactory,
            favoritesRepository: Creator.injectFavoritesRepository()
        )
        
        //when
        var photos = [PhotoModel]()
        imageListPresenter.setPhotosObserver{ response in
            guard let response else {
                XCTFail("Null result from photos request")
                return
            }
            photos.append(contentsOf: response)
        }
        
        imageListPresenter.getPhotosNextPage()
        imageListPresenter.getPhotosNextPage()
        
        //then
        XCTAssertEqual(photos.count, 20)
        XCTAssertNotEqual(photos[0].id, photos[10].id)
        
    }
    
    func testPhotosRequestError() throws {
        //given
        var errorOnPhotosRequest = false
        var errorDescription = ""
        let photoFactory = PhotoFactory(
            photosRepository: PhotoRepositoryStab(),
            tokenRepository: TokenRepositoryStab()
        )
        let imageListPresenter = ImageListPresenter(
            photoFactory: photoFactory,
            favoritesRepository: Creator.injectFavoritesRepository()
        )
        
        //when
        imageListPresenter.setErrorStateObserver { errorModel in
            guard let errorModel else {
                XCTFail("No error callback")
                return
            }
            errorOnPhotosRequest = true
            errorDescription = errorModel.message
        }
        imageListPresenter.getPhotosNextPage()
        
        //then
        XCTAssertTrue(errorOnPhotosRequest)
        XCTAssertEqual(errorDescription, "Ошибка 404")
    }
    
    func testChangeLike() throws {
        let photoFactory = PhotoFactory(
            photosRepository: PhotoRepositoryStab(),
            tokenRepository: TokenRepositoryStab()
        )
        let imageListPresenter = ImageListPresenter(
            photoFactory: photoFactory,
            favoritesRepository: FavoritesRepositoryStab()
        )
        
        //when
        var photos = [PhotoModel]()
        var responsePhotoModelOnChangeLike: PhotoModel?
        imageListPresenter.setPhotosObserver{ response in
            guard let response else {
                XCTFail("Null result from photos request")
                return
            }
            photos.append(contentsOf: response)
        }
        
        imageListPresenter.getPhotosNextPage()
        imageListPresenter.changeLike(for: photos[0]) { response in
            responsePhotoModelOnChangeLike = response
        }
        
        XCTAssertNotEqual(photos[0].isLiked, responsePhotoModelOnChangeLike?.isLiked)
    }
}
