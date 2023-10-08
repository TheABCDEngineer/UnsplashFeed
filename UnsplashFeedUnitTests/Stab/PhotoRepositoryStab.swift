//
//  PhotoRepositoryStab.swift
//  UnsplashFeedUnitTests
//
//  Created by Avtor_103 on 06.10.2023.
//

import Foundation
@testable import UnsplashFeed

final class PhotoRepositoryStab: PhotoRepository {
    func fetchPhotosNextPage(
        page: Int,
        perPage: Int,
        token: String,
        onSuccess: @escaping ([PhotoModel]) -> Void,
        onFailure: @escaping (NetworkError) -> Void
    ) {
        var result = [PhotoModel]()
        for _ in 1...10 {
            result.append(randomPhotoModel(page, 10))
        }
        
        onSuccess(result)
        onFailure(.httpStatusCode(404))
    }
    
    private func randomPhotoModel(_ page: Int, _ perPage:Int) -> PhotoModel {
        return PhotoModel(
            id: "\(page)\(perPage)",
            size: CGSize(width: Double(page), height: Double(perPage)),
            createdAt: nil,
            welcomeDescription: nil,
            thumbImageURL: nil,
            largeImageURL: nil,
            isLiked: false
        )
    }
    
    
}
