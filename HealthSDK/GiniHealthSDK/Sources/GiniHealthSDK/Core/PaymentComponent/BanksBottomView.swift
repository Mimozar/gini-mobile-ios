//
//  PaymentProvidersBottomView.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//


import UIKit

class BanksBottomView: BottomSheetViewController {

    var viewModel: BanksBottomViewModel
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: .greatestFiniteMagnitude, height: Constants.heightTitleView)
        view.backgroundColor = .clear
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.selectBankTitleText
        label.textColor = viewModel.selectBankLabelAccentColor
        label.font = viewModel.selectBankLabelFont
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var closeTitleIconImageView: UIImageView = {
        let imageView = UIImageView(image: viewModel.closeTitleIcon.withRenderingMode(.alwaysTemplate))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = viewModel.closeIconAccentColor
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnCloseIcon)))
        return imageView
    }()
    
    private lazy var descriptionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.descriptionText
        label.textColor = viewModel.descriptionLabelAccentColor
        label.font = viewModel.descriptionLabelFont
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var paymentProvidersView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var paymentProvidersTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: BankSelectionTableViewCell.identifier,
                                 bundle: Bundle.resource),
                           forCellReuseIdentifier: BankSelectionTableViewCell.identifier)
        tableView.estimatedRowHeight = viewModel.rowHeight
        tableView.rowHeight = viewModel.rowHeight
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var moreInformationView: MoreInformationView = {
        let view = MoreInformationView()
        let viewModel = MoreInformationViewModel()
        viewModel.delegate = self
        view.viewModel = viewModel
        return view
    }()

    private lazy var poweredByGiniView: PoweredByGiniView = {
        let view = PoweredByGiniView()
        view.viewModel = PoweredByGiniViewModel()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    init(viewModel: BanksBottomViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        setupViewHierarchy()
        setupViewAttributes()
        setupLayout()
    }

    private func setupViewHierarchy() {
        titleView.addSubview(titleLabel)
        titleView.addSubview(closeTitleIconImageView)
        contentStackView.addArrangedSubview(titleView)
        descriptionView.addSubview(descriptionLabel)
        contentStackView.addArrangedSubview(descriptionView)
        paymentProvidersView.addSubview(paymentProvidersTableView)
        contentStackView.addArrangedSubview(paymentProvidersView)
        contentStackView.addArrangedSubview(poweredByGiniView)
        bottomStackView.addArrangedSubview(moreInformationView)
        bottomStackView.addArrangedSubview(UIView())
        bottomStackView.addArrangedSubview(poweredByGiniView)
        bottomView.addSubview(bottomStackView)
        contentStackView.addArrangedSubview(bottomView)
        self.setContent(content: contentStackView)
    }

    private func setupViewAttributes() {
        let isFullScreen = viewModel.bottomViewHeight >= viewModel.maximumViewHeight
        paymentProvidersTableView.isScrollEnabled = isFullScreen
    }

    private func setupLayout() {
        setupTitleViewConstraints()
        setupDescriptionConstraints()
        setupTableViewConstraints()
        setupPoweredByGiniConstraints()
    }

    private func setupTitleViewConstraints() {
        NSLayoutConstraint.activate([
            titleView.heightAnchor.constraint(equalToConstant: Constants.heightTitleView),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: Constants.viewPaddingConstraint),
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            closeTitleIconImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeTitleIconImageView.heightAnchor.constraint(equalToConstant: Constants.closeIconSize),
            closeTitleIconImageView.widthAnchor.constraint(equalToConstant: Constants.closeIconSize),
            closeTitleIconImageView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -Constants.viewPaddingConstraint),
            closeTitleIconImageView.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: Constants.titleViewTitleIconSpacing)
        ])
    }

    private func setupDescriptionConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: Constants.viewPaddingConstraint),
            descriptionLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -Constants.viewPaddingConstraint),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: -Constants.viewPaddingConstraint)
        ])
    }

    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            paymentProvidersTableView.topAnchor.constraint(equalTo: paymentProvidersView.topAnchor),
            paymentProvidersTableView.leadingAnchor.constraint(equalTo: paymentProvidersView.leadingAnchor, constant: Constants.viewPaddingConstraint),
            paymentProvidersTableView.trailingAnchor.constraint(equalTo: paymentProvidersView.trailingAnchor, constant: -Constants.viewPaddingConstraint),
            paymentProvidersTableView.bottomAnchor.constraint(equalTo: paymentProvidersView.bottomAnchor),
            paymentProvidersTableView.heightAnchor.constraint(equalToConstant: viewModel.heightTableView)
        ])
    }

    private func setupPoweredByGiniConstraints() {
        NSLayoutConstraint.activate([
            bottomStackView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: Constants.viewPaddingConstraint),
            bottomStackView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -Constants.viewPaddingConstraint),
            bottomStackView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: Constants.topAnchorPoweredByGiniConstraint),
            bottomStackView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor)
        ])
    }
    
    @objc
    private func tapOnCloseIcon() {
        viewModel.didTapOnClose()
    }
    
    private func openPaymentProvidersAppStoreLink(urlString: String?) {
        guard let urlString = urlString else {
            print("AppStore link unavailable for this payment provider")
            return
        }
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

extension BanksBottomView {
    enum Constants {
        static let heightTitleView = 48.0
        static let viewPaddingConstraint = 16.0
        static let topAnchorTitleView = 32.0
        static let closeIconSize = 24.0
        static let titleViewTitleIconSpacing = 10.0
        static let topAnchorPoweredByGiniConstraint = 5.0
    }
}

extension BanksBottomView: MoreInformationViewProtocol {
    func didTapOnMoreInformation() {
        viewModel.didTapOnMoreInformation()
    }
}

extension BanksBottomView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.paymentProviders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BankSelectionTableViewCell.identifier, 
                                                       for: indexPath) as? BankSelectionTableViewCell else {
            return UITableViewCell()
        }
        let invoiceTableViewCellModel = viewModel.paymentProvidersViewModel(paymentProvider: viewModel.paymentProviders[indexPath.row])
        cell.cellViewModel = invoiceTableViewCellModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.viewDelegate?.didSelectPaymentProvider(paymentProvider: viewModel.paymentProviders[indexPath.row].paymentProvider)
    }
}
