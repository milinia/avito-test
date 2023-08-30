//
//  ProductCollectionViewCellPresenter.swift
//  avito-test
//
//  Created by Evelina on 29.08.2023.
//

import Foundation

protocol ProductCellOutput {
    func loadImage(imageUrl: String)
    var view: ProductCellInput? { get set }
}

class ProductCollectionViewCellPresenter: ProductCellOutput {

    private let imageService: ImageServiceProtocol
    weak var view: ProductCellInput?
    
    init(imageService: ImageServiceProtocol, view: ProductCellInput) {
        self.imageService = imageService
        self.view = view
    }
    
    func loadImage(imageUrl: String) {
        imageService.fetchImage(imageUrl: imageUrl) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.view?.setImage(image: image)
                }
            case .failure(_):
                break
            }
        }
    }
}
