//
//  ProductListVCMock.swift
//  avito-testTests
//
//  Created by Evelina on 31.08.2023.
//

import Foundation
@testable import avito_test

final class ProductListVCMock: ProductListViewInput {
    
    var errorWasShown: Bool = false
    var collectionViewWasUpdated: Bool = false
    var vcUpdated: (() -> Void)?
    
    func updateCollectionView() {
        collectionViewWasUpdated = true
        vcUpdated?()
    }
    
    func showLoading() {}
    
    func showError() {
        errorWasShown = true
        vcUpdated?()
    }
}
