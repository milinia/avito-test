//
//  ProductData.swift
//  avito-test
//
//  Created by Evelina on 24.08.2023.
//

import Foundation

struct ProductData: Codable {
    let id: String
    let title: String
    let price: String
    let location: String
    let imageUrl: String
    let createdDate: String
}

struct ResponseData: Codable {
    let advertisements: [ProductData]
}
