import UIKit

final class SplashViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private let authViewIdentifier = "AuthViewController"
    private let mainControllerIndetifier = "TabBarViewController"
    private let presenter = Creator.createSplashViewPresenter()
    private var isViewAllreadyAppeared = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if presenter.getAuthorizationStatus() {
            if !isViewAllreadyAppeared { loadProfile() }
        } else {
            isViewAllreadyAppeared = true
            switchToAuthController()
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
    func configureLayout() {
        view.backgroundColor = .ypBlack
        let launchImage = UIImageView()
        launchImage.image = UIImage(named: "LaunchIcon")
        launchImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(launchImage)
        
        launchImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        launchImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func switchToAuthController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let authViewController = storyboard.instantiateViewController(
            withIdentifier: authViewIdentifier
        ) as? AuthViewController else { fatalError("Can't create AuthViewController")}
        
        authViewController.modalPresentationStyle = .fullScreen
        authViewController.setDelegate(self)
        self.present(authViewController, animated: true)
    }
    
    func onLoadProfileFailure(with error: Error) {
        
    }
}
