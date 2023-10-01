import Foundation

final class SplashViewPresenter {
    private let profileLoader: ProfileLoaderProtocol
    private let tokenRepository: OAuth2TokenRepository
    
    init(profileLoader: ProfileLoaderProtocol,
         tokenRepository: OAuth2TokenRepository
    ) {
        self.profileLoader = profileLoader
        self.tokenRepository = tokenRepository
    }
    
    func getAuthorizationStatus() -> Bool {
        let token = tokenRepository.getToken()
        if token.isEmpty { return false }
        return true
    }
    
    func loadProfile(
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (Error) -> Void
    ) {
        profileLoader.loadProfileInformation { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.loadProfileUrl(from: profile)
                onSuccess()
            case .failure(let error):
                onFailure(error)
            }
        }
    }
    
    private func loadProfileUrl(from profile: ProfilePropertiesModel) {
        profileLoader.loadProfileImageUrl(profile: profile) { _ in }
    }    
}

