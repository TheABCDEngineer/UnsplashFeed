//
//  WebViewPresenter.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 13.08.2023.
//

import Foundation
import WebKit

final class WebViewPresenter: WebViewPresenterProtocol {
    private let authHelper: AuthHelperProtocol
    private let urlRequestObsevable = ObservableData<URLRequest>()
    private let webLoadingProgressObservable = ObservableData<ProgressState>()
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func onViewDidLoad() {
        guard let request = authHelper.authRequest() else {
            assertionFailure("Can't create UrlRequest")
            return
        }
        urlRequestObsevable.postValue(request)
    }
    
    func handleNavigationAction(
        url: URL?,
        completion: @escaping (String) -> Void
    ) -> WKNavigationActionPolicy {
        if let code = fetchCode(from: url) {
            completion(code)
            return .cancel
        } else {
            return .allow
        }
    }
    
    func updateProgressValue(_ value: Double) {
        let progressState = ProgressState(
            progressValue: Float(value),
            isHiden: fabs(value - 1.0) <= 0.0001
        )
        webLoadingProgressObservable.postValue(progressState)
    }
    
//MARK: - Private methods    
    private func fetchCode(from url: URL?) -> String? {
        return authHelper.code(from: url)
    }
}
//MARK: - set View Observers
extension WebViewPresenter {
    func urlRequestObserve(_ completion: @escaping (URLRequest?) -> Void) {
        urlRequestObsevable.observe(completion)
    }
    
    func webLoadingProgressObserve(_ completion: @escaping (ProgressState?) -> Void) {
        webLoadingProgressObservable.observe(completion)
    }
}
