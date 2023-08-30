//
//  ProductCollectionViewCell.swift
//  avito-test
//
//  Created by Evelina on 25.08.2023.
//

import UIKit

protocol ProductCellInput: AnyObject {
    func setImage(image: Data?)
}

class ProductCollectionViewCell: UICollectionViewCell {
    // MARK: - Private constants
    private enum UIConstants {
        static let titleLabelFontSize: CGFloat = 16
        static let contentInset: CGFloat = 16
        static let cellCornerRadius: CGFloat = 10
    }
    // MARK: - Private UI properties
    private lazy var productImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .clear
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIConstants.titleLabelFontSize)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.titleLabelFontSize)
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: UIConstants.titleLabelFontSize)
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: UIConstants.titleLabelFontSize)
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .black
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeShadow()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
        presenter?.view = nil
        presenter = nil
        [titleLabel, priceLabel, addressLabel, dateLabel].forEach({$0.text = nil})
    }
    private var presenter: ProductCellOutput?
    // MARK: - Public functions
    func configure(with product: ProductData, presenter: ProductCellOutput) {
//        productImage.image = UIImage(data: product.image ?? Data())
//        productImage.image = UIImage(named: "image")
        titleLabel.text = product.title
        priceLabel.text = product.price
        addressLabel.text = product.location
        dateLabel.text = product.createdDate
        loadingView.startAnimating()
        self.presenter = presenter
        presenter.loadImage(imageUrl: product.imageUrl)
    }
    // MARK: - Private functions
    private func makeShadow() {
        layer.cornerRadius =  UIConstants.cellCornerRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 1.5
        layer.masksToBounds =  false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: UIConstants.cellCornerRadius).cgPath
    }
    private func initialize() {
        backgroundColor = .white
        contentView.layer.cornerRadius = UIConstants.cellCornerRadius
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillProportionally
        verticalStack.alignment = .leading
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        [titleLabel, priceLabel, addressLabel, dateLabel].forEach({verticalStack.addArrangedSubview($0)})
        [productImage, verticalStack, loadingView].forEach({addSubview($0)})
        NSLayoutConstraint.activate([
            productImage.leftAnchor.constraint(equalTo: leftAnchor),
            productImage.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            productImage.widthAnchor.constraint(equalTo: widthAnchor),
            productImage.heightAnchor.constraint(equalToConstant: 150),
            
            loadingView.centerXAnchor.constraint(equalTo: productImage.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: productImage.centerYAnchor),
            
            verticalStack.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 16),
            verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            verticalStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            verticalStack.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}
extension ProductCollectionViewCell: ProductCellInput {
    func setImage(image: Data?) {
        loadingView.stopAnimating()
        productImage.image = UIImage(data: image ?? Data())
    }
}
