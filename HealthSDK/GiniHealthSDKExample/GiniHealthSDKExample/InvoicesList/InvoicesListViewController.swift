//
//  InvoicesListViewController.swift
//
//  Copyright © 2024 Gini GmbH. All rights reserved.
//


import UIKit

final class InvoicesListViewController: UIViewController {
    
    // MARK: - Variables
    lazy var invoicesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: InvoiceTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InvoiceTableViewCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: Constants.padding, left: 0, bottom: Constants.padding, right: 0)
        tableView.separatorColor = viewModel.tableViewSeparatorCalor
        tableView.estimatedRowHeight = Constants.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
//        tableView.register(UINib(nibName: "PaymentComponentView", bundle: viewModel.healthSDKBundle), forCellReuseIdentifier: InvoiceTableViewCell.identifier)
        return tableView
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .gray
        }
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    var viewModel: InvoicesListViewModel!
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        title = viewModel.titleText
        view.backgroundColor = viewModel.backgroundColor
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        if #available(iOS 15.0, *) {
            invoicesTableView.sectionHeaderTopPadding = 0
         }
        view.addSubview(invoicesTableView)

        NSLayoutConstraint.activate([
            invoicesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.padding * 2),
            invoicesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding * 2),
            invoicesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding * 2),
            invoicesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                    constant: -Constants.padding * 2)
        ])
    }
    
    private func setupNavigationBar() {
        let uploadInvoiceItem = UIBarButtonItem(title: viewModel.uploadInvoicesText, style: .plain, target: self, action: #selector(uploadInvoices))
        self.navigationItem.rightBarButtonItem = uploadInvoiceItem
    }
    
    @objc func uploadInvoices() {
        viewModel.uploadInvoices()
    }
}

extension InvoicesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InvoiceTableViewCell.identifier, for: indexPath) as? InvoiceTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.cellViewModel = viewModel.invoices.map { InvoiceTableViewCellModel(invoice: $0, giniConfiguration: viewModel.giniConfiguration) }[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.invoices.isEmpty {
            let label = UILabel()
            label.text = viewModel.noInvoicesText
            label.textAlignment = .center
            tableView.backgroundView = label
            tableView.separatorStyle = .none
            return 0
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            return 1
        }
    }
}

extension InvoicesListViewController: InvoicesViewControllerProtocol {
    func showActivityIndicator() {
        self.activityIndicator.startAnimating()
        self.view.addSubview(self.activityIndicator)
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.invoicesTableView.reloadData()
        }
    }
}

extension InvoicesListViewController {
    private enum Constants {
        static let padding: CGFloat = 8
        static let cornerRadius: CGFloat = 16
        static let rowHeight: CGFloat = 80
    }
}
