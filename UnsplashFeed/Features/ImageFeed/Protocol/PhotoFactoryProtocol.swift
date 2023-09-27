import Foundation

protocol PhotoFactoryProtocol {
    func setCallbacks(
        onSuccess: @escaping ([PhotoModel]) -> Void,
        onFailure: @escaping (NetworkError) -> Void
    )
    
    func getPhotosNextPage()
}
