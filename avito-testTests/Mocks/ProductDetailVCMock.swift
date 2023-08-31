//
//  ProductDetailVCMock.swift
//  avito-testTests
//
//  Created by Evelina on 31.08.2023.
//

import Foundation
@testable import avito_test

final class ProductDetailVCMock: DetailViewInput {
    
    var errorWasShown: Bool = false
    var screenWasUpdated: Bool = false
    var vcUpdated: (() -> Void)?
    
    func updateProductData(product: avito_test.ProductDetailModel) {
        screenWasUpdated = true
        vcUpdated?()
    }
    
    func showLoading() {}
    
    func showError() {
        errorWasShown = true
        vcUpdated?()
    }
}
