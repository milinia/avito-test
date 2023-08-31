//
//  ProductListPresenterTests.swift
//  avito-testTests
//
//  Created by Evelina on 31.08.2023.
//

import XCTest
@testable import avito_test

final class ProductListPresenterTests: XCTestCase {
    
    private var presenter: ProductListPresenter!
    private var productServiceMock: ProductServiceMock!
    private var imageServiceMock: ImageServiceMock!
    private var productListVCMock: ProductListVCMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        productServiceMock = ProductServiceMock()
        imageServiceMock = ImageServiceMock()
        productListVCMock = ProductListVCMock()
        presenter = ProductListPresenter(productService: productServiceMock, imageService: imageServiceMock)
        presenter.view = productListVCMock
    }

    override func tearDownWithError() throws {
        productServiceMock = nil
        imageServiceMock = nil
        productListVCMock = nil
        presenter = nil
    }

    func testGoodResponse() throws {
        presenter.loadProducts()
        let expectation = self.expectation(description: "View updated by presenter")
        productListVCMock.vcUpdated = {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(productListVCMock.collectionViewWasUpdated)
        XCTAssertFalse(productListVCMock.errorWasShown)
    }
    
    func testBadResponse() throws {
        productServiceMock.isFailureResponse = true
        presenter.loadProducts()
        let expectation = self.expectation(description: "View updated by presenter")
        productListVCMock.vcUpdated = {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(productListVCMock.errorWasShown)
        XCTAssertFalse(productListVCMock.collectionViewWasUpdated)
    }
}
