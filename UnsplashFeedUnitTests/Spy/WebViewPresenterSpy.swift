import Foundation
import WebKit
@testable import UnsplashFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled = false
    
    func onViewDidLoad() {
        self.viewDidLoadCalled = true
    }
    
    func handleNavigationAction(
        url: URL?,
        completion: @escaping (String) -> Void
    ) -> WKNavigationActionPolicy {
        return .cancel
    }
    
    func updateProgressValue(_ value: Double) {
        
    }
    
    func urlRequestObserve(_ completion: @escaping (URLRequest?) -> Void) {
        
    }
    
    func webLoadingProgressObserve(_ completion: @escaping (ProgressState?) -> Void) {
        
    }
    
    
}
