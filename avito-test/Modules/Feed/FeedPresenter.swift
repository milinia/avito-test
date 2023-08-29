//
//  FeedPresenter.swift
//  avito-test
//
//  Created by Evelina on 25.08.2023.
//

import Foundation

class FeedPresenter {
    // MARK: - Private properties
    private var productService: ProductServiceProtocol
    private var products: [ProductData] = []
    // MARK: - Public properties
    weak var view: FeedViewInput?
    var didTapToOpenProduct: ((ProductData) -> Void)?
    // MARK: - Init
    init(productService: ProductServiceProtocol) {
        self.productService = productService
    }
}
extension FeedPresenter: FeedViewOutput {
    func viewDidTapToOpenProduct(with index: Int) {
        didTapToOpenProduct?(products[index])
    }
    func loadProducts() {
        view?.showLoading()
        productService.fetchProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
                DispatchQueue.main.async {
                    self?.view?.updateCollectionView()
                }
            case .failure:
                DispatchQueue.main.async {
                    self?.view?.showError()
                }
            }
        }
    }
    func productsCount() -> Int {
        return products.count
    }
    
    func productByIndex(index: Int) -> ProductData {
        return products[index]
    }
}
