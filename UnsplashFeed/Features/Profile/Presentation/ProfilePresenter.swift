import Foundation

final class ProfilePresenter {
    private let profileRepository: ProfileRepository
    private let tokenRepository: OAuth2TokenRepository
    private var profileLoaderObserver: NSObjectProtocol?
    
    init(
        profileRepository: ProfileRepository,
        tokenRepository: OAuth2TokenRepository
    ) {
        self.profileRepository = profileRepository
        self.tokenRepository = tokenRepository
    }
    
    func getProfileInformation() -> ProfilePropertiesModel {
        if let profile = profileRepository.properties {
            return profile
        }
        return ProfilePropertiesModel(userName: "", name: "", loginName: "", bio: "")
    }
    
    func provideProfileAvatar(
        completion: @escaping (URL?) -> Void
    ) {
       profileLoaderObserver = NotificationCenter
            .default
            .addObserver(
                forName: Creator.OnProfileAvatarUrlDidLoad,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                completion(
                    self.profileRepository.avatarUrl
                )
            }
        completion(
            profileRepository.avatarUrl
        )
    }
    
    func onProfileLogout(completion: @escaping () -> Void) -> AlertDialogModel {
        return AlertDialog.createDialogModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            applyTitle: "Да",
            cancelTitle: "Нет",
            applyAction: { [weak self] _ in
                guard let self else { return }
                self.tokenRepository.removeToken()
                Creator.cleanWebCookies()
                completion()
            },
            cancelAction: { _ in}
        )
    }
}
