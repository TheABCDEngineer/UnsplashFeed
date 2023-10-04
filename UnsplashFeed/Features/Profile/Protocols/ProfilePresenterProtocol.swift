import Foundation

protocol ProfilePresenterProtocol {
    func getProfileInformation() -> ProfilePropertiesModel
    
    func provideProfileAvatar(completion: @escaping (URL?) -> Void)
    
    func onProfileLogout(completion: @escaping () -> Void) -> AlertDialogModel
}
