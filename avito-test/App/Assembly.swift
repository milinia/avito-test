//
//  Assembly.swift
//  avito-test
//
//  Created by Evelina on 24.08.2023.
//

import Foundation

protocol AssemblyProtocol {
    var requestApiManager: RequestApiManager { get }
    var networkManager: NetworkManagerProtocol { get }
    var dateFormatter: DateFormatterManagerProtocol { get }
    var productService: ProductServiceProtocol { get }
}

final class Assembly: AssemblyProtocol {
    lazy var requestApiManager: RequestApiManager = RequestApiManager()
    lazy var networkManager: NetworkManagerProtocol = NetworkManager()
    lazy var dateFormatter: DateFormatterManagerProtocol = DateFormatterManager()
    lazy var productService: ProductServiceProtocol = ProductService(networkManager: networkManager,
                                                                     requestManager: requestApiManager,
                                                                     dateFormatter: dateFormatter)
}
