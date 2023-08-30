//
//  FlowCoordinator.swift
//  avito-test
//
//  Created by Evelina on 24.08.2023.
//

import UIKit

final class FlowCoordinator {
    
    private let navigationViewController: UINavigationController
    private let assemby: AssemblyProtocol
    
    init(navigationViewController: UINavigationController, assemby: AssemblyProtocol) {
        self.navigationViewController = navigationViewController
        self.navigationViewController.navigationBar.tintColor = .black
        self.assemby = assemby
    }
    
    func start() {
        let productListPresenter = ProductListPresenter(productService: assemby.productService, imageService: assemby.imageService)
        productListPresenter.didTapToOpenProduct = wantsToOpenProductDetail
        let productListView = ProductListViewController(productListPresenter: productListPresenter)
        productListPresenter.view = productListView
        navigationViewController.pushViewController(productListView, animated: true)
    }
    
    func wantsToOpenProductDetail(with product: ProductData) {
        let detailPresenter = DetailPresenter(productService: assemby.productService, product: product)
        let detailView = DetailViewController(detailPresenter: detailPresenter)
        detailPresenter.view = detailView
        navigationViewController.pushViewController(detailView, animated: true)
    }
}
