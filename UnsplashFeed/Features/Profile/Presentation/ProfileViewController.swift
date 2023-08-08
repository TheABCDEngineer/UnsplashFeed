//
//  ProfileViewController.swift
//  UnsplashFeed
//
//  Created by Avtor_103 on 06.08.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private var userImageView: UIImageView!
    private var userNameView: UILabel!
    private var userLinkView: UILabel!
    private var userSelfStatusView: UILabel!
    private var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        configureLayout()
        
        //будет пустым до авторизации и будет заменено реальными данными юзера после авторизации
        userImageView.image = UIImage(named: "userImageMock")
        userNameView.text = "Екатерина Новикова"
        userLinkView.text = "@ekaterina_nov"
        userSelfStatusView.text = "Hello, world!"
    }
    
    @objc
    private func onLogoutButtonClick() {
     
    }
}

extension ProfileViewController {
    private func configureLayout() {
        let userImageSupperView = UIImageView()
        userImageSupperView.image = UIImage(systemName: "circle.fill")
        userImageSupperView.tintColor = .ypWhite
        userImageSupperView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userImageSupperView)
        userImageSupperView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userImageSupperView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userImageSupperView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 16
        ).isActive = true
        userImageSupperView.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: 76
        ).isActive = true
        
        userImageView = UIImageView()
        userImageView.image = UIImage(systemName: "person.crop.circle.fill")
        userImageView.tintColor = .ypGray
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userImageSupperView.addSubview(userImageView)
        
        userNameView = UILabel()
        initUserPropertyLabel(
            label: userNameView,
            textColor: .ypWhite,
            font: .boldSystemFont(ofSize: 23),
            previousLabelBottomAnchor: userImageSupperView.bottomAnchor
        )
        
        userLinkView = UILabel()
        initUserPropertyLabel(
            label: userLinkView,
            textColor: .ypGray,
            font: .systemFont(ofSize: 13),
            previousLabelBottomAnchor: userNameView.bottomAnchor
        )
        
        userSelfStatusView = UILabel()
        initUserPropertyLabel(
            label: userSelfStatusView,
            textColor: .ypWhite,
            font: .systemFont(ofSize: 13),
            previousLabelBottomAnchor: userLinkView.bottomAnchor
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
            equalTo: userImageSupperView.centerYAnchor
        ).isActive = true
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
