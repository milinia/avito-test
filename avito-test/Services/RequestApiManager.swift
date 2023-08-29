//
//  RequestApiManager.swift
//  avito-test
//
//  Created by Evelina on 24.08.2023.
//

import Foundation

protocol RequestApiManagerProtocol {
    func mainPageRequest() -> String
    func productByIdRequest(id: String) -> String
}

final class RequestApiManager: RequestApiManagerProtocol {
    func mainPageRequest() -> String {
        return "https://www.avito.st/s/interns-ios/main-page.json"
    }
    func productByIdRequest(id: String) -> String {
        return "https://www.avito.st/s/interns-ios/details/\(id).json"
    }
}
