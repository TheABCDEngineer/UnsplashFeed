import Foundation

final class URLSessionService {
    private var task: URLSessionTask?
    private var previousSessionSettings: SessionSettings?
    
    func fetch<T: Decodable>(
        urlPath: String,
        httpMethod: String,
        header: String? = nil,
        headerField: String? = nil,
        responseBody: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ){
        assert(Thread.isMainThread)
        let currentSessionSettings = SessionSettings(
            urlPath: urlPath,
            httpMethod: httpMethod,
            header: header,
            headerField: headerField
        )
        if previousSessionSettings == currentSessionSettings { return }
        previousSessionSettings = currentSessionSettings
        task?.cancel()
        
        guard let url = URL(string: urlPath) else {
            completion(
                .failure(NetworkError.urlError("Can't create URL from \(urlPath)"))
            )
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        if headerField != nil {
            request.setValue(header, forHTTPHeaderField: headerField!)
        }
        
        let decoder = JSONDecoder()
        
        task = URLSession.shared.data(for: request) { [weak self] (result: Result<Data, Error>) in
            guard let self else { fatalError("URLSassionService failed") }
            
            let response = result.flatMap { data -> Result<T, Error> in
                Result { try decoder.decode(T.self, from: data) }
            }
            switch response {
            case .success(let body):
                completion(.success(body))
            case .failure(let error):
                completion(.failure(error))
            }
            self.previousSessionSettings = nil
            self.task = nil
        }
        
        task?.resume()
    }
}

private extension URLSessionService {
    struct SessionSettings: Equatable {
        let urlPath: String
        let httpMethod: String
        let header: String?
        let headerField: String?
    }
}
