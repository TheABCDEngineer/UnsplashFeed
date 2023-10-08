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
    private weak var appLauncherDelegate: AppLauncherProtocol?
    private let webViewIdentifier = "ShowWebView"
    private let presenter = Creator.createAuthViewPresenter()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case webViewIdentifier:
            guard let viewController = segue.destination as? WebViewController else {
                assertionFailure("Can't find WebViewController")
                return
            }
            viewController.setDelegate(self)
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func setDelegate(_ delegate: AppLauncherProtocol) {
        self.appLauncherDelegate = delegate
    }
    
    @IBAction private func onLoginButtonClick() {
        performSegue(withIdentifier: webViewIdentifier, sender: nil)
    }
}

//MARK: - Private funcs
private extension AuthViewController {
    func onAuthorizationFalture(error: Error) {
        AlertDialog.showAlert(
            self,
            model: presenter.createAuthorizationFaltureAlertDialog(
                errorDescription: error.localizedDescription
            ) { _ in}
        )
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
                self.appLauncherDelegate?.loadProfile()
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

//MARK: - AlertPresenterProtocol
extension AuthViewController: AlertPresenterProtocol {
    func present(_ alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}
