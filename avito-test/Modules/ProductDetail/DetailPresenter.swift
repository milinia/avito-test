//
//  DetailPresenter.swift
//  avito-test
//
//  Created by Evelina on 25.08.2023.
//

import Foundation


final class DetailPresenter: DetailViewOutput {
    
    // MARK: - Private properties
    private var productService: ProductServiceProtocol
    private var product: ProductData
    // MARK: - Public properties
    weak var view: DetailViewInput?
    var productDetail: ProductDetailModel?
    // MARK: - Init
    init(productService: ProductServiceProtocol, product: ProductData) {
        self.productService = productService
        self.product = product
    }
    // MARK: -
    func loadProductDetail() {
        view?.showLoading()
        productService.fetchProductDetailById(id: product.id) { [weak self] result in
            switch result {
            case .success(let productDetail):
                self?.productDetail = productDetail
                DispatchQueue.main.async {
                    self?.view?.updateProductData(product: productDetail)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.view?.showError()
                }
            }
        }
    }
}
