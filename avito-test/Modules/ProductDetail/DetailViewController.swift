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
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
//        view.contentSize = CGSize(width: view.frame.width, height: 900)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    private lazy var contentView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var stackViewForData: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var horizontalButtonStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.distribution = .fillProportionally
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK: - Private functions
    private func setupView() {
        view.backgroundColor = .white
        [callButton, writeButton].forEach({horizontalButtonStack.addArrangedSubview($0)})
        [priceLabel, titleLabel, addressLabel, sellerTitleLabel,
         phoneNumberLabel, emailLabel, horizontalButtonStack, descriptionTitleLabel,descriptionLabel,
         dateLabel].forEach({stackViewForData.addArrangedSubview($0)})
        [productImage, stackViewForData].forEach({contentView.addArrangedSubview($0)})
        [scrollView, loadingView, errorLabel].forEach({view.addSubview($0)})
        scrollView.addSubview(contentView)
        setupContraints()
        callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        writeButton.addTarget(self, action: #selector(writeButtonTapped), for: .touchUpInside)
        
        contentView.setCustomSpacing(10, after: productImage)
        
        stackViewForData.setCustomSpacing(10, after: titleLabel)
        stackViewForData.setCustomSpacing(16, after: addressLabel)
        stackViewForData.setCustomSpacing(20, after: descriptionLabel)
        stackViewForData.setCustomSpacing(6, after: sellerTitleLabel)
        stackViewForData.setCustomSpacing(6, after: descriptionTitleLabel)
        stackViewForData.setCustomSpacing(20, after: horizontalButtonStack)
        stackViewForData.setCustomSpacing(6, after: phoneNumberLabel)
        stackViewForData.setCustomSpacing(10, after: emailLabel)
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
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        
            stackViewForData.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -30),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            productImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            productImage.heightAnchor.constraint(equalToConstant: UIConstants.imageViewHeight),

            titleLabel.widthAnchor.constraint(equalTo: stackViewForData.widthAnchor, constant: -2 * UIConstants.contentInset),

            addressLabel.widthAnchor.constraint(equalTo: stackViewForData.widthAnchor, constant: -2 * UIConstants.contentInset),

            horizontalButtonStack.widthAnchor.constraint(equalTo: stackViewForData.widthAnchor),
            horizontalButtonStack.heightAnchor.constraint(equalToConstant: UIConstants.buttonStackViewHeight),

            descriptionLabel.widthAnchor.constraint(equalTo: stackViewForData.widthAnchor, constant: -2 * UIConstants.contentInset)
        ])
    }
}
extension DetailViewController: DetailViewInput {
    func updateProductData(product: ProductDetailModel) {
        
        loadingView.stopAnimating()
        
        scrollView.isHidden = false
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
        scrollView.isHidden = true
        errorLabel.isHidden = true
    }
    
    func showError() {
        loadingView.stopAnimating()
        scrollView.isHidden = true
        errorLabel.isHidden = false
    }
}
