//
//  AuthViewController.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 12.08.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private let webViewIdentifier = "ShowWebView"
    private let mainControllerIndetifier = "TabBarViewController"
    private let presenter = Creator.createAuthViewPresenter()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case webViewIdentifier:
            let viewController = segue.destination as! WebViewController
            viewController.setDelegate(self)
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    @IBAction private func onLoginButtonClick() {
        performSegue(withIdentifier: webViewIdentifier, sender: nil)
    }
}

//MARK: - Private funcs
private extension AuthViewController {
    func switchToMainController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let mainController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: mainControllerIndetifier)
        window.rootViewController = mainController
    }
    
    func onAuthorizationFalture(error: Error) {
        //ошибка авторизации
    }
}

//MARK: - WebViewControllerDelegate
extension AuthViewController: WebViewControllerDelegate {
    func webViewController(_ viewController: WebViewController, authenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        presenter.provideAuthorization(code: code) { [weak self] error in
            guard let self = self else { return }
            guard let result = error else {
                UIBlockingProgressHUD.dismiss()
                switchToMainController()
                return
            }
            UIBlockingProgressHUD.dismiss()
            onAuthorizationFalture(error: result)
        }
    }
    
    func webViewControllerCancel(_ viewController: WebViewController) {
        dismiss(animated: true)
    }
}
