//
//  DetailViewController.swift
//  avito-test
//
//  Created by Evelina on 24.08.2023.
//

import UIKit

protocol DetailViewOutput {
    var productDetail: ProductDetailModel? { get set }
    func loadProductDetail()
}

protocol DetailViewInput: ViewInput {
    func updateProductData(product: ProductDetailModel)
}

class DetailViewController: UIViewController {
    // MARK: - Private constants
    private enum UIConstants {
        static let errorLabelFontSize: CGFloat = 20
        static let titleLabelFontSize: CGFloat = 22
        static let regularFontSize: CGFloat = 16
        static let contentInset: CGFloat = 16
        static let imageViewHeight: CGFloat = 320
        static let buttonStackViewHeight: CGFloat = 45
        static let buttonCornerRadius: CGFloat = 10
    }
    // MARK: - Private UI properties
    private lazy var productImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .systemGray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIConstants.titleLabelFontSize)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.titleLabelFontSize + 5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIConstants.regularFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIConstants.regularFontSize)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.titleLabelFontSize)
        label.text = StringContants.description
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var sellerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: UIConstants.titleLabelFontSize)
        label.text = StringContants.seller
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: UIConstants.regularFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: UIConstants.regularFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var callButton: UIButton = {
        let button = UIButton()
        button.setTitle(StringContants.call, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = UIConstants.buttonCornerRadius
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIConstants.regularFontSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var writeButton: UIButton = {
        let button = UIButton()
        button.setTitle(StringContants.write, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = UIConstants.buttonCornerRadius
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIConstants.regularFontSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: UIConstants.regularFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var contentView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.contentSize = CGSize(width: view.frame.width, height: 900)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
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
    private var state: ScreenState = .success
    private var detailPresenter: DetailViewOutput
    // MARK: - Init
    init(detailPresenter: DetailViewOutput) {
        self.detailPresenter = detailPresenter
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
        detailPresenter.loadProductDetail()
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        contentView.contentSize = CGSize(width: view.frame.width, height: dateLabel.frame.maxY + 100)
//        print(dateLabel.frame.maxY)
//    }
    // MARK: - Private functions
    private func setupView() {
        view.backgroundColor = .white
        [productImage, titleLabel, priceLabel, descriptionLabel, descriptionTitleLabel, sellerTitleLabel,
         phoneNumberLabel, emailLabel, dateLabel, addressLabel].forEach({contentView.addSubview($0)})
        [contentView, loadingView, errorLabel].forEach({view.addSubview($0)})
        setupContraints()
        callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        writeButton.addTarget(self, action: #selector(writeButtonTapped), for: .touchUpInside)
    }
    @objc func callButtonTapped() {
        let originalString = phoneNumberLabel.text ?? ""
        let numbersOnly = originalString.compactMap { char -> String? in
            return "0123456789".contains(char) ? String(char) : nil
        }.joined()
        guard let number = URL(string: "tel:\(numbersOnly)") else { return }
        if UIApplication.shared.canOpenURL(number) {
            UIApplication.shared.open(number)
        }
    }
    @objc func writeButtonTapped() {
        guard let emailURL = URL(string: "mailto:\(String(describing: emailLabel.text))") else { return }
        if UIApplication.shared.canOpenURL(emailURL) {
            UIApplication.shared.open(emailURL)
        }
    }
    private func setupContraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        let horizontalButtonStack = UIStackView()
        horizontalButtonStack.axis = .horizontal
        horizontalButtonStack.spacing = 10
        horizontalButtonStack.distribution = .fillProportionally
        horizontalButtonStack.translatesAutoresizingMaskIntoConstraints = false
        [callButton, writeButton].forEach({horizontalButtonStack.addArrangedSubview($0)})
        [horizontalButtonStack].forEach({contentView.addSubview($0)})
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            productImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            productImage.heightAnchor.constraint(equalToConstant: UIConstants.imageViewHeight),
            
            priceLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 10),
            priceLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIConstants.contentInset),
            
            titleLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: UIConstants.contentInset),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIConstants.contentInset),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -2 * UIConstants.contentInset),
            
            addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UIConstants.contentInset),
            addressLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIConstants.contentInset),
            addressLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -2 * UIConstants.contentInset),
            
            sellerTitleLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 2 * UIConstants.contentInset),
            sellerTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIConstants.contentInset),
            
            phoneNumberLabel.topAnchor.constraint(equalTo: sellerTitleLabel.bottomAnchor, constant: UIConstants.contentInset),
            phoneNumberLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIConstants.contentInset),
            
            emailLabel.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 6),
            emailLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIConstants.contentInset),
            
            horizontalButtonStack.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            horizontalButtonStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            horizontalButtonStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            horizontalButtonStack.heightAnchor.constraint(equalToConstant: UIConstants.buttonStackViewHeight),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: callButton.bottomAnchor, constant: UIConstants.contentInset),
            descriptionTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIConstants.contentInset),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: UIConstants.contentInset),
            descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIConstants.contentInset),
            descriptionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -2 * UIConstants.contentInset),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: UIConstants.contentInset),
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIConstants.contentInset)
        ])
    }
}
extension DetailViewController: DetailViewInput {
    func updateProductData(product: ProductDetailModel) {
        
        loadingView.stopAnimating()
        contentView.isHidden = false
        errorLabel.isHidden = true
            
        priceLabel.text = product.price
        productImage.image = UIImage(data: product.image)
        titleLabel.text = product.title
        addressLabel.text = "\(product.location), \(product.address)"
        descriptionLabel.text = product.description
        phoneNumberLabel.text = product.phoneNumber
        emailLabel.text = product.email
        dateLabel.text = StringContants.published + " " + product.createdDate
    }
    func showLoading() {
        loadingView.startAnimating()
        contentView.isHidden = true
        errorLabel.isHidden = true
    }
    
    func showError() {
        loadingView.stopAnimating()
        contentView.isHidden = true
        errorLabel.isHidden = false
    }
}
