import Foundation

final class ProfileLoader: ProfileLoaderProtocol {
    static var shared: ProfileLoader?
    
    private let profileService: ProfileServiceProtocol
    private let profileRepository: ProfileRepository
    private let tokenRepository: OAuth2TokenRepository
    
    init(
        profileService: ProfileServiceProtocol,
        profileRepository: ProfileRepository,
        tokenRepository: OAuth2TokenRepository
    ) {
        self.profileService = profileService
        self.profileRepository = profileRepository
        self.tokenRepository = tokenRepository
    }
    
    func loadProfileInformation(
        completion: @escaping (Result<ProfilePropertiesModel, Error>) -> Void
    ) {
        let token = self.tokenRepository.getToken()
        if token.isEmpty {
            completion(.failure(NetworkError.tokenError("Can't load token from repository")))
            return
        }
        profileService.fetchProfileProperties(token: token) { result in
            switch result {
            case .success(let profile):
                self.profileRepository.saveProfileProperties(profile)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadProfileImageUrl(
        profile: ProfilePropertiesModel,
        completion: @escaping (Result<URL?, Error>) -> Void
    ) {
        let token = self.tokenRepository.getToken()
        if token.isEmpty {
            completion(.failure(NetworkError.tokenError("Can't load token from repository")))
            return
        }
        profileService.fetchProfileImageUrl(
            token: token,
            userName: profile.userName,
            imageSizeAttribute: "small"
        ) { result in
            switch result {
            case .success(let stringUrl):
                var url: URL? = nil
                if let stringUrl {
                    url = URL(string: stringUrl)
                }
                self.profileRepository.saveProfileAvatarUrl(url)
                self.sendNotification(with: Creator.OnProfileAvatarUrlDidLoad)
                completion(.success(url))
            
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension ProfileLoader {
    func sendNotification(with name: Notification.Name) {
        NotificationCenter
            .default
            .post(
                name: name,
                object: self
            )
    }
}
