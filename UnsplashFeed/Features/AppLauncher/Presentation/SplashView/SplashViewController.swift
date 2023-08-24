import UIKit

final class SplashViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private let authViewIdentifier = "ShowAuthView"
    private let mainControllerIndetifier = "TabBarViewController"
    private let presenter = Creator.createSplashViewPresenter()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if presenter.getAuthorizationStatus() {
            loadProfile()
        } else {
            performSegue(withIdentifier: authViewIdentifier, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case authViewIdentifier:
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to \(authViewIdentifier)") }
            
            viewController.setDelegate(self)
            
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AppLauncherProtocol {
    func loadProfile() {
        UIBlockingProgressHUD.show()
        presenter.loadProfile(
            onSuccess: { [weak self] in
                guard let self else { return }
                UIBlockingProgressHUD.dismiss()
                self.switchToMainController()
            },
            onFailure: { [weak self] error in
                guard let self else { return }
                UIBlockingProgressHUD.dismiss()
                self.onLoadProfileFailure(with: error)
            }
        )
    }
    
    func switchToMainController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let mainController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: mainControllerIndetifier)
        window.rootViewController = mainController
    }
}

private extension SplashViewController {
    func onLoadProfileFailure(with error: Error) {
        
    }
}
