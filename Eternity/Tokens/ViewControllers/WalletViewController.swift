// Copyright SIX DAY LLC. All rights reserved.

import UIKit

enum DetailsViewType: Int {
    case tokens
    case nonFungibleTokens
}

class WalletViewController: UIViewController {

    var tokensViewController: TokensViewController
    var nonFungibleTokensViewController: NonFungibleTokensViewController

    init(
        tokensViewController: TokensViewController,
        nonFungibleTokensViewController: NonFungibleTokensViewController
    ) {
        self.tokensViewController = tokensViewController
        self.nonFungibleTokensViewController = nonFungibleTokensViewController
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 15))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo_header")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.titleView = imageView
        setupView()
    }

    private func setupView() {
        updateView()
    }

    private func updateView() {
        /*if segmentController.selectedSegmentIndex == DetailsViewType.tokens.rawValue {
            showBarButtonItems()
            remove(asChildViewController: nonFungibleTokensViewController)
            add(asChildViewController: tokensViewController)
        } else {
            hideBarButtonItems()
            remove(asChildViewController: tokensViewController)
            add(asChildViewController: nonFungibleTokensViewController)
        }*/
        showBarButtonItems()
        remove(asChildViewController: nonFungibleTokensViewController)
        add(asChildViewController: tokensViewController)
        
    }

    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }

    private func showBarButtonItems() {
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.leftBarButtonItem?.isEnabled = true
    }

    private func hideBarButtonItems() {
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WalletViewController: Scrollable {
    func scrollOnTop() {
        tokensViewController.tableView.scrollOnTop()
    }
}
