import Foundation

protocol WebViewControllerDelegate: AnyObject {
    func webViewController(_ viewController: WebViewController, authenticateWithCode code: String)
    func webViewControllerCancel(_ viewController: WebViewController)
}
