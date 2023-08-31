//
//  ProductServiceMock.swift
//  avito-testTests
//
//  Created by Evelina on 31.08.2023.
//

import Foundation
@testable import avito_test

enum RequestError: Error {
    case badResponse
}

final class ProductServiceMock: ProductServiceProtocol {
    
    var isFailureResponse: Bool = false
    
    func fetchProducts(completion: @escaping (Result<[avito_test.ProductData], Error>) -> Void) {
        if isFailureResponse {
            completion(.failure(RequestError.badResponse))
        } else {
            completion(.success([ProductData(id: "1",
                                             title: "1",
                                             price: "1",
                                             location: "1",
                                             imageUrl: "1",
                                             createdDate: "1")]))
        }
    }
    
    func fetchProductDetailById(id: String, completion: @escaping (Result<avito_test.ProductDetailModel, Error>) -> Void) {
        if isFailureResponse {
            completion(.failure(RequestError.badResponse))
        } else {
            completion(.success(ProductDetailModel(id: "1",
                                                   title: "1",
                                                   price: "1",
                                                   location: "1",
                                                   image: Data(),
                                                   createdDate: "1",
                                                   description: "1",
                                                   email: "1",
                                                   phoneNumber: "1",
                                                   address: "1")))
        }
    }
}
