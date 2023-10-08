//
//  ProfileViewController.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 06.08.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private var userAvatarView: UIImageView!
    private var profileNameView: UILabel!
    private var loginNameView: UILabel!
    private var profileBioView: UILabel!
    private var logoutButton: UIButton!
    
    var presenter = Creator.createProfilePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        configureLayout()
        
        updateProfileProperties(
            presenter.getProfileInformation()
        )
        
        presenter.provideProfileAvatar{ [weak self] url in
            guard let self else { return }
            self.updateProfileAvatar(for: url)
        }
    }
    
    @objc
    private func onLogoutButtonClick() {
        let logoutDialogModel = presenter.onProfileLogout {
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid Configuration when logout")
                return
            }
            window.rootViewController = SplashViewController()
        }
        AlertDialog.showAlert(self, model: logoutDialogModel)
    }
    
    private func updateProfileProperties(_ model: ProfilePropertiesModel) {
        profileNameView.text = model.name
        loginNameView.text = model.loginName
        profileBioView.text = model.bio
    }
    
    private func updateProfileAvatar(for url: URL?) {
        let processor = RoundCornerImageProcessor(cornerRadius: 40)
        userAvatarView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "person.crop.circle.fill"),
            options: [.processor(processor)]
        )
        userAvatarView.layer.cornerRadius = 40
    }
}

//MARK: - AlertPresenterProtocol
extension ProfileViewController: AlertPresenterProtocol {
    func present(_ alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}

//MARK: - Config methods
extension ProfileViewController {
    private func configureLayout() {
        userAvatarView = UIImageView()
        userAvatarView.image = UIImage(systemName: "person.crop.circle.fill")
        userAvatarView.tintColor = .ypGray
        userAvatarView.backgroundColor = .ypWhite
        userAvatarView.translatesAutoresizingMaskIntoConstraints = false
        userAvatarView.layer.cornerRadius = 56
        view.addSubview(userAvatarView)
        userAvatarView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userAvatarView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userAvatarView.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor,
                    constant: 16
        ).isActive = true
        userAvatarView.topAnchor.constraint(
                    equalTo: view.topAnchor,
                    constant: 76
        ).isActive = true
        
        profileNameView = UILabel()
        initUserPropertyLabel(
            label: profileNameView,
            textColor: .ypWhite,
            font: .boldSystemFont(ofSize: 23),
            previousLabelBottomAnchor: userAvatarView.bottomAnchor
        )
        
        loginNameView = UILabel()
        initUserPropertyLabel(
            label: loginNameView,
            textColor: .ypGray,
            font: .systemFont(ofSize: 13),
            previousLabelBottomAnchor: profileNameView.bottomAnchor
        )
        
        profileBioView = UILabel()
        initUserPropertyLabel(
            label: profileBioView,
            textColor: .ypWhite,
            font: .systemFont(ofSize: 13),
            previousLabelBottomAnchor: loginNameView.bottomAnchor
        )
        
        logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(self.onLogoutButtonClick)
        )
        logoutButton.tintColor = .ypRed
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        view.addSubview(logoutButton)
        logoutButton.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -24
        ).isActive = true
        logoutButton.centerYAnchor.constraint(
            equalTo: userAvatarView.centerYAnchor
        ).isActive = true
        logoutButton.accessibilityIdentifier = "LogoutButton"
    }
    
    private func initUserPropertyLabel(
        label: UILabel,
        textColor: UIColor,
        font: UIFont,
        previousLabelBottomAnchor: NSLayoutYAxisAnchor
    ) {
        label.textColor = textColor
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 16
        ).isActive = true
        label.topAnchor.constraint(
            equalTo: previousLabelBottomAnchor,
            constant: 8
        ).isActive = true
    }
}
