import Foundation

final class ProfilePresenter {
    private let profileService: ProfileServiceProtocol
    private let tokenRepository: OAuth2TokenRepository
    
    init(profileService: ProfileServiceProtocol, tokenRepository: OAuth2TokenRepository) {
        self.profileService = profileService
        self.tokenRepository = tokenRepository
    }
        
    func getProfileInformation(
        completion: @escaping (Result<ProfileModel, Error>) -> Void
    ) {
        guard let token = tokenRepository.getToken() else {
            completion(.failure(NetworkError.tokenError("Can't load token from repository")))
            return
        }
        
        profileService.fetchProfileProperties(token: token) { [weak self] result in
            guard let self else { return }
            switch result {
            
            case .success(let profile):
                self.getProfileImageUrl(
                    token: token,
                    userName: profile.userName) { _result in
                    
                        var profileModel: ProfileModel?
                        switch _result {
                        case .success(let stringUrl):
                            profileModel = DataConverter.swapToProfileModel(
                                stringUrl,
                                profile
                            )
                        case .failure(_):
                            profileModel = DataConverter.swapToProfileModel(
                                nil,
                                profile
                            )
                        }
                        guard let profileModel else { fatalError("ProfileModel failed") }
                        completion(.success(profileModel))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getProfileImageUrl(
        token: String,
        userName: String,
        completion: @escaping (Result<String?, Error>) -> Void
    ) {
        profileService.fetchProfileImageUrl(
            token: token,
            userName: userName,
            imageSizeAttribute: "small"
        ) { result in
            switch result {
            case .success(let url):
                completion(.success(url))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
