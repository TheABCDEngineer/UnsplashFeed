import Foundation

final class PhotoRepositoryImplNetwork: PhotoRepository {
    private let urlSessionService = URLSessionService()

    func fetchPhotosNextPage(
        page: Int,
        perPage: Int,
        token: String,
        onSuccess: @escaping ([PhotoModel]) -> Void,
        onFailure: @escaping (NetworkError) -> Void
    ) {
        urlSessionService.fetch(
            urlPath: urlPath(page: page, perPage: perPage),
            httpMethod: HttpMethod.GET,
            header: "Bearer \(token)",
            headerField: "Authorization",
            responseBody: [PhotoResponseBody].self
        ) { (result: Result<[PhotoResponseBody], Error>) in
            switch result {
            case .success(let PhotoResponseBodyList):
                onSuccess(
                    DataConverter.mapPhotos(dtoList: PhotoResponseBodyList)
                )
            case .failure(let error):
                onFailure(.urlRequestError(error))
            }
        }
    }
    
    private func urlPath(page: Int, perPage: Int) -> String {
        return "\(AuthConfiguration.standart.defaultBaseURL)/photos?page=\(page)&per_page=\(perPage)"
    }
    
}
