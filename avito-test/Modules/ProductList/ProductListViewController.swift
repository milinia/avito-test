//
//  ProductListViewController.swift
//  avito-test
//
//  Created by Evelina on 24.08.2023.
//

import UIKit

protocol ViewInput: AnyObject {
    func showLoading()
    func showError()
}

protocol ProductListViewInput: AnyObject, ViewInput {
    func updateCollectionView()
}

protocol ProductListViewOutput {
    func viewDidTapToOpenProduct(with index: Int)
    func loadProducts()
    func productsCount() -> Int
    func productByIndex(index: Int) -> ProductData
    func getImageService() -> ImageServiceProtocol
}

class ProductListViewController: UIViewController {
    // MARK: - Private constants
    private enum UIConstants {
        static let errorLabelFontSize: CGFloat = 20
        static let contentInset: CGFloat = 16
        static let productCellHeight: CGFloat = 280
    }
    // MARK: - Private UI properties
    private lazy var productCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(named: "collectionViewBackgroundColor")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .black
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = StringContants.error
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.errorLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    // MARK: - Private properties
    private let productListPresenter: ProductListViewOutput
    // MARK: - Init
    init(productListPresenter: ProductListViewOutput) {
        self.productListPresenter = productListPresenter
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - UIViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        showLoading()
        productListPresenter.loadProducts()
    }
    // MARK: - Private functions
    private func setupView() {
        navigationItem.title = ""
        view.backgroundColor = .white
        [productCollectionView, loadingView, errorLabel].forEach({view.addSubview($0)})
        setupCollectionView()
        setupContraints()
    }
    private func setupContraints() {
        NSLayoutConstraint.activate([
            productCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            productCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            productCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            productCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    private func setupCollectionView() {
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.register(ProductCollectionViewCell.self,
                                       forCellWithReuseIdentifier: String(describing: ProductCollectionViewCell.self))
    }
}
extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productListPresenter.productsCount()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ProductCollectionViewCell.self),
            for: indexPath) as? ProductCollectionViewCell else { return ProductCollectionViewCell()}
        let cellPresenter: ProductCellOutput = ProductCollectionViewCellPresenter(imageService: productListPresenter.getImageService(),
                                                                                  view: cell)
        cell.configure(with: productListPresenter.productByIndex(index: indexPath.row), presenter: cellPresenter)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        productListPresenter.viewDidTapToOpenProduct(with: indexPath.row)
    }
}
extension ProductListViewController: ProductListViewInput {
    func showLoading() {
        loadingView.startAnimating()
        errorLabel.isHidden = true
    }
    
    func showError() {
        loadingView.stopAnimating()
        errorLabel.isHidden = false
        productCollectionView.isHidden = true
    }
    
    func updateCollectionView() {
        loadingView.stopAnimating()
        errorLabel.isHidden = true
        productCollectionView.isHidden = false
        productCollectionView.reloadData()
    }
}
extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width - 16
        let itemHeight = UIConstants.productCellHeight
        let itemWidth = collectionViewWidth / 2
        return CGSize(width: Double(itemWidth), height: Double(itemHeight))
    }
}
