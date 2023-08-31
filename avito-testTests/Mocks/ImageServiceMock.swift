//
//  ImageServiceMock.swift
//  avito-testTests
//
//  Created by Evelina on 31.08.2023.
//

import Foundation
@testable import avito_test

final class ImageServiceMock: ImageServiceProtocol {
    var isFailureResponse: Bool = false
    
    func fetchImage(imageUrl: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if isFailureResponse {
            completion(.failure(RequestError.badResponse))
        } else {
            completion(.success(Data()))
        }
    }
}
