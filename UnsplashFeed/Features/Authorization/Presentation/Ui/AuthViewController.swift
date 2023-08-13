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
    @IBOutlet weak var loginButtonView: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButtonView.isHidden = true
        if presenter.getAuthorizationStatus() {
            switchToMainController()
        } else {
            print("loginButtonView.isHidden = false")
            loginButtonView.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case webViewIdentifier:
            let viewController = segue.destination as! WebViewController
            viewController.setDelegate(self)
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    @IBAction func onLoginButtonClick() {
        performSegue(withIdentifier: webViewIdentifier, sender: nil)
    }
}

private extension AuthViewController {
    func switchToMainController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let mainController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: mainControllerIndetifier)
        window.rootViewController = mainController
    }
}

extension AuthViewController: WebViewControllerDelegate {
    func webViewController(_ viewController: WebViewController, authenticateWithCode code: String) {
        if presenter.provideAuthorization(code: code) == nil {
            switchToMainController()
        } else {
            //ошибка авторизации
        }
    }
    
    func webViewControllerCancel(_ viewController: WebViewController) {
        dismiss(animated: true)
    }
}
