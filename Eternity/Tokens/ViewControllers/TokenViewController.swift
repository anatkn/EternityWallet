// Copyright SIX DAY LLC. All rights reserved.

import UIKit
import StatefulViewController

protocol TokenViewControllerDelegate: class {
    func didPressRequest(for token: TokenObject, in controller: UIViewController)
    func didPressSend(for token: TokenObject, in controller: UIViewController)
    func didPress(transaction: Transaction, in controller: UIViewController)
}

class TokenViewController: UIViewController {

    private let refreshControl = UIRefreshControl()

    private var tableView = TransactionsTableView()

    private lazy var header: TokenHeaderView = {
        let view = TokenHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 242))
        return view
    }()

    private var insets: UIEdgeInsets {
        return UIEdgeInsets(top: header.frame.height + 100, left: 0, bottom: 60, right: 0)
    }

    private var viewModel: TokenViewModel

    weak var delegate: TokenViewControllerDelegate?

    let bg : UIImageView = {
        let bgIV = UIImageView()
        bgIV.translatesAutoresizingMaskIntoConstraints = true
        bgIV.image = UIImage(named: "main_bg")
        bgIV.contentMode = UIViewContentMode.scaleAspectFill
        return bgIV
    }()
    
    init(viewModel: TokenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        navigationItem.title = viewModel.title
        view.backgroundColor = .clear
        bg.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(bg)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        header.backgroundColor = .clear
        tableView.tableHeaderView = header
        tableView.tableFooterView = UIView()
        tableView.register(TransactionViewCell.self, forCellReuseIdentifier: TransactionViewCell.identifier)
        tableView.separatorColor = Colors.veryVeryLightGray
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        view.addSubview(tableView)
        tableView.separatorInset = UIEdgeInsets.zero
         tableView.layoutMargins = UIEdgeInsets.zero
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])

        refreshControl.tintColor = Colors.purple
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)

        header.buttonsView.requestButton.addTarget(self, action: #selector(request), for: .touchUpInside)
        header.buttonsView.sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        updateHeader()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        observToken()
        observTransactions()
        configTableViewStates()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInitialViewState()
        fetch()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func fetch() {
        startLoading()
        viewModel.fetch()
    }

    private func observToken() {
        viewModel.tokenObservation { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.updateHeader()
            self?.endLoading()
        }
    }

    private func observTransactions() {
        viewModel.transactionObservation { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
            self?.endLoading()
        }
    }

    private func updateHeader() {
        header.imageView.kf.setImage(
            with: viewModel.imageURL,
            placeholder: viewModel.imagePlaceholder
        )
        header.amountLabel.text = viewModel.amount
        header.amountLabel.font = viewModel.amountFont
        header.amountLabel.textColor = Colors.purple

        header.fiatAmountLabel.text = viewModel.totalFiatAmount
        header.fiatAmountLabel.font = viewModel.fiatAmountFont
        header.fiatAmountLabel.textColor = Colors.purple

//        header.currencyAmountLabel.text = viewModel.currencyAmount
//        header.currencyAmountLabel.textColor = viewModel.currencyAmountTextColor
//        header.currencyAmountLabel.font = viewModel.currencyAmountFont
//
        header.percentChange.text = viewModel.percentChange
        header.percentChange.textColor = viewModel.percentChangeColor
        header.percentChange.font = viewModel.percentChangeFont
    }

    @objc func pullToRefresh() {
        refreshControl.beginRefreshing()
        fetch()
    }

    @objc func send() {
        delegate?.didPressSend(for: viewModel.token, in: self)
    }

    @objc func request() {
        delegate?.didPressRequest(for: viewModel.token, in: self)
    }

    deinit {
        viewModel.invalidateObservers()
    }

    private func configTableViewStates() {
        errorView = ErrorView(insets: insets, onRetry: { [weak self] in
            self?.fetch()
        })
        loadingView = LoadingView(insets: insets)
        emptyView = TransactionsEmptyView(insets: insets)
    }
}

extension TokenViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionViewCell.identifier, for: indexPath) as! TransactionViewCell
        cell.configure(viewModel: viewModel.cellViewModel(for: indexPath))
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(for: section)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewModel.hederView(for: section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return StyleLayout.TableView.heightForHeaderInSection
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didPress(transaction: viewModel.item(for: indexPath.row, section: indexPath.section), in: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TokenViewController: StatefulViewController {
    func hasContent() -> Bool {
        return viewModel.hasContent()
    }
}
