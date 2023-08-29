//
//  ProductService.swift
//  avito-test
//
//  Created by Evelina on 29.08.2023.
//

import Foundation

protocol ProductServiceProtocol {
    func fetchProducts(completion: @escaping (Result<[ProductData], Error>) -> Void)
    func fetchProductDetailById(id: String, completion: @escaping (Result<ProductDetailModel, Error>) -> Void)
    func fetchImage(imageUrl: String, completion: @escaping (Result<Data, Error>) -> Void)
}

final class ProductService: ProductServiceProtocol {
    private var networkManager: NetworkManagerProtocol
    private var requestManager: RequestApiManagerProtocol
    private var dateFormatter: DateFormatterManagerProtocol
    
    init(networkManager: NetworkManagerProtocol, requestManager: RequestApiManagerProtocol, dateFormatter: DateFormatterManagerProtocol) {
        self.networkManager = networkManager
        self.requestManager = requestManager
        self.dateFormatter = dateFormatter
    }
    
    func fetchProducts(completion: @escaping (Result<[ProductData], Error>) -> Void) {
        networkManager.makeRequest(url: requestManager.mainPageRequest()) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseData = try decoder.decode(ResponseData.self, from: data)
                    completion(.success(responseData.advertisements))
                } catch let decodeError {
                    completion(.failure(decodeError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchImage(imageUrl: String, completion: @escaping (Result<Data, Error>) -> Void) {
        networkManager.makeRequest(url: imageUrl) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchProductDetailById(id: String, completion: @escaping (Result<ProductDetailModel, Error>) -> Void) {
        networkManager.makeRequest(url: requestManager.productByIdRequest(id: id)) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let product = try decoder.decode(ProductDetailData.self, from: data)
                    self.fetchImage(imageUrl: product.imageUrl) { result in
                        switch result {
                        case .success(let image):
                            completion(.success(ProductDetailModel(id: product.id,
                                                                   title: product.title,
                                                                   price: product.price,
                                                                   location: product.location,
                                                                   image: image,
                                                                   createdDate: self.dateFormatter.formatDate(stringDate: product.createdDate),
                                                                   description: product.description,
                                                                   email: product.email,
                                                                   phoneNumber: product.phoneNumber,
                                                                   address: product.address)))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } catch let decodeError {
                    completion(.failure(decodeError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
