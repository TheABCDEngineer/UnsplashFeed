import Foundation

final class ProfilePresenter {
    private let profileRepository: ProfileRepository
    private var profileLoaderObserver: NSObjectProtocol?
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
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
}
