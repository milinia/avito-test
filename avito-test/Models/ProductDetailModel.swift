//
//  ProductDetailModel.swift
//  avito-test
//
//  Created by Evelina on 27.08.2023.
//

import Foundation

struct ProductDetailModel: Codable {
    let id: String
    let title: String
    let price: String
    let location: String
    let image: Data
    let createdDate: String
    let description: String
    let email: String
    let phoneNumber: String
    let address: String
}
