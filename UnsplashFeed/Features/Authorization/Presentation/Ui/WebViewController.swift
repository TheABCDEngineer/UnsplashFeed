//
//  WebViewController.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 12.08.2023.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    private let presenter = Creator.createWebViewPresenter()
    weak private var delegate: WebViewControllerDelegate?
    @IBOutlet weak private var webView: WKWebView!
    @IBOutlet weak private var progressView: UIProgressView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(
            URLRequest(url: presenter.getWebUrl())
        )
        webView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }

    func setDelegate(_ delegate: WebViewControllerDelegate) {
        self.delegate = delegate
    }
    
    @IBAction func onBackButtonClick() {
        delegate?.webViewControllerCancel(self)
    }
}

private extension WebViewController {
    func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        decisionHandler(
            presenter.handleNavigationAction(url: navigationAction.request.url) { [weak self] code in
                guard let self = self else { return }
                self.delegate?.webViewController(self, authenticateWithCode: code)
            }
        )
    }
}
