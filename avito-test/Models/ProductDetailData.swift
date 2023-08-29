//
//  ProductDetailData.swift
//  avito-test
//
//  Created by Evelina on 24.08.2023.
//

import Foundation

struct ProductDetailData: Codable {
    let id: String
    let title: String
    let price: String
    let location: String
    let imageUrl: String
    let createdDate: String
    let description: String
    let email: String
    let phoneNumber: String
    let address: String
}
