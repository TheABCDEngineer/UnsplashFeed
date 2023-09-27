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
    private weak var delegate: WebViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
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
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
            options: [],
            changeHandler: { [weak self] _, _ in
                guard let self = self else { return }
                self.updateProgress()
            }
        )
    }
    
    func setDelegate(_ delegate: WebViewControllerDelegate) {
        self.delegate = delegate
    }
    
    @IBAction func onBackButtonClick() {
        delegate?.webViewControllerCancel(self)
    }
}

//MARK: - Private funcs
private extension WebViewController {
    func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

//MARK: - WKNavigationDelegate
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
                self.dismiss(animated: true)
            }
        )
    }
}
