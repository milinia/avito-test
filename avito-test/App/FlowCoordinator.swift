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
        let feedPresenter = FeedPresenter(productService: assemby.productService)
        feedPresenter.didTapToOpenProduct = wantsToOpenProductDetail
        let feedView = FeedViewController(feedPresenter: feedPresenter)
        feedPresenter.view = feedView
        navigationViewController.pushViewController(feedView, animated: true)
    }
    
    func wantsToOpenProductDetail(with product: ProductData) {
        let detailPresenter = DetailPresenter(productService: assemby.productService, product: product)
        let detailView = DetailViewController(detailPresenter: detailPresenter)
        detailPresenter.view = detailView
        navigationViewController.pushViewController(detailView, animated: true)
    }
}
