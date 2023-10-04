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
        webView.navigationDelegate = self
        presenter.urlRequestObserve{ [weak self] request in
            guard let self else { return }
            guard let request else { return }
            self.updateWebSite(request)
        }
        presenter.webLoadingProgressObserve{ [weak self] state in
            guard let self else { return }
            guard let state else { return }
            self.setProgressValue(state.progressValue)
            self.setProgressHidden(state.isHiden)
        }
        presenter.onViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
            options: [],
            changeHandler: { [weak self] _, _ in
                guard let self = self else { return }
                presenter.updateProgressValue(webView.estimatedProgress)
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
    func updateWebSite(_ request: URLRequest) {
        webView.load(request)
    }

    func setProgressValue(_ value: Float) {
        progressView.progress = value
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
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
