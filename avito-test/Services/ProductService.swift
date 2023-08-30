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
}

final class ProductService: ProductServiceProtocol {
    private var networkManager: NetworkManagerProtocol
    private var requestManager: RequestApiManagerProtocol
    private var dateFormatter: DateFormatterManagerProtocol
    private var imageService: ImageServiceProtocol
    
    init(networkManager: NetworkManagerProtocol, requestManager: RequestApiManagerProtocol,
         dateFormatter: DateFormatterManagerProtocol, imageService: ImageServiceProtocol) {
        self.networkManager = networkManager
        self.requestManager = requestManager
        self.dateFormatter = dateFormatter
        self.imageService = imageService
    }
    
    func fetchProducts(completion: @escaping (Result<[ProductData], Error>) -> Void) {
        networkManager.makeRequest(url: requestManager.mainPageRequest()) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseData = try decoder.decode(ResponseData.self, from: data)
                    let products = responseData.advertisements.map({ProductData(id: $0.id,
                                                                                title: $0.title,
                                                                                price: $0.price,
                                                                                location: $0.location,
                                                                                imageUrl: $0.imageUrl,
                                                                                createdDate: self.dateFormatter.formatDate(stringDate: $0.createdDate))})
                    completion(.success(products))
                } catch let decodeError {
                    completion(.failure(decodeError))
                }
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
                    print(String(decoding: data, as: UTF8.self))
                    let product = try decoder.decode(ProductDetailData.self, from: data)
                    self.imageService.fetchImage(imageUrl: product.imageUrl) { result in
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
