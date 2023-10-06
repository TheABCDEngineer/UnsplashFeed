import Foundation
import XCTest
@testable import UnsplashFeed

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() throws {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: "WebViewController"
        ) as? WebViewController else {
            fatalError("Can't find WebViewController")
        }
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() throws {
        //given
        var loadRequest: URLRequest?
        
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        presenter.urlRequestObserve{ request in
            guard let request else { return }
            loadRequest = request
        }
        
        //when
        presenter.onViewDidLoad()
        
        //then
        XCTAssertNotNil(loadRequest)
    }
    
    func testProgressVisibleWhenLessThenOne() throws {
        //given
        let progress: Double = 0.6
        var shouldHideProgress: Bool?
        
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        presenter.webLoadingProgressObserve{ state in
            guard let state else { return }
            shouldHideProgress = state.isHiden
        }
        
        //when
        presenter.updateProgressValue(progress)
        
        //then
        XCTAssertNotNil(shouldHideProgress)
        
        guard let shouldHideProgress else { fatalError() }
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() throws {
        //given
        let progress: Double = 1.0
        var shouldHideProgress: Bool?
        
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        presenter.webLoadingProgressObserve{ state in
            guard let state else { return }
            shouldHideProgress = state.isHiden
        }
        
        //when
        presenter.updateProgressValue(progress)
        
        //then
        XCTAssertNotNil(shouldHideProgress)
        
        guard let shouldHideProgress else {
            XCTFail("unexpected nil shouldHideProgress")
            return
        }
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() throws {
        //given
        let configuration = AuthConfiguration.standart
        let authHelper = AuthHelper()
        
        //when
        guard let url = authHelper.authURL() else {
            XCTFail("unexpected nil url")
            return
        }
        let urlString = url.absoluteString
        
        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        //given
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native") else {
            XCTFail("Can't create class URLComponents")
            return
        }
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        
        guard let url = urlComponents.url else {
            XCTFail("Can't create url from URLComponents")
            return
        }
        let authHelper = AuthHelper()
        
        //when
        let code = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(code, "test code")
    }
}

