import Foundation
import WebKit

protocol WebViewPresenterProtocol {
    func onViewDidLoad()
    
    func handleNavigationAction(
        url: URL?,
        completion: @escaping (String) -> Void
    ) -> WKNavigationActionPolicy
    
    func updateProgressValue(_ value: Double)
    
    func urlRequestObserve(_ completion: @escaping (URLRequest?) -> Void)
    func webLoadingProgressObserve(_ completion: @escaping (ProgressState?) -> Void)
}
