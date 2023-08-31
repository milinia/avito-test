//
//  ProductDetailPresenterTests.swift
//  avito-testTests
//
//  Created by Evelina on 31.08.2023.
//

import XCTest
@testable import avito_test

final class ProductDetailPresenterTests: XCTestCase {

    private var presenter: DetailPresenter!
    private var productServiceMock: ProductServiceMock!
    private var productDetailVCMock: ProductDetailVCMock!

    override func setUpWithError() throws {
        try super.setUpWithError()
        productServiceMock = ProductServiceMock()
        productDetailVCMock = ProductDetailVCMock()
        presenter = DetailPresenter(productService: productServiceMock, product: ProductData(id: "1",
                                                                                             title: "1",
                                                                                             price: "1",
                                                                                             location: "1",
                                                                                             imageUrl: "1",
                                                                                             createdDate: "1"))
        presenter.view = productDetailVCMock
    }

    override func tearDownWithError() throws {
        productServiceMock = nil
        productDetailVCMock = nil
        presenter = nil
    }

    func testGoodResponse() throws {
        presenter.loadProductDetail()
        let expectation = self.expectation(description: "View updated by presenter")
        productDetailVCMock.vcUpdated = {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(productDetailVCMock.screenWasUpdated)
        XCTAssertFalse(productDetailVCMock.errorWasShown)
    }
    
    func testBadResponse() throws {
        productServiceMock.isFailureResponse = true
        presenter.loadProductDetail()
        let expectation = self.expectation(description: "View updated by presenter")
        productDetailVCMock.vcUpdated = {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(productDetailVCMock.errorWasShown)
        XCTAssertFalse(productDetailVCMock.screenWasUpdated)
    }
}
