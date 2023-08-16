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
            switchToMainController()
        } else {
            performSegue(withIdentifier: authViewIdentifier, sender: nil)
        }
    }
        
    private func switchToMainController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let mainController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: mainControllerIndetifier)
        window.rootViewController = mainController
    }
}
