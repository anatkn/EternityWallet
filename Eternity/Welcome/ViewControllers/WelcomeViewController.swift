// Copyright SIX DAY LLC. All rights reserved.

import UIKit

protocol WelcomeViewControllerDelegate: class {
    func didPressCreateWallet(in viewController: WelcomeViewController)
    func didPressImportWallet(in viewController: WelcomeViewController)
}

class WelcomeViewController: UIViewController {

    var viewModel = WelcomeViewModel()
    weak var delegate: WelcomeViewControllerDelegate?

    lazy var collectionViewController: OnboardingCollectionViewController = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let collectionViewController = OnboardingCollectionViewController(collectionViewLayout: layout)
        collectionViewController.pages = pages
        collectionViewController.collectionView?.isPagingEnabled = true
        collectionViewController.collectionView?.showsHorizontalScrollIndicator = false
        collectionViewController.collectionView?.backgroundColor = UIColor.clear
        return collectionViewController
    }()
    let bg : UIImageView = {
        let bgIV = UIImageView()
        bgIV.translatesAutoresizingMaskIntoConstraints = true
        bgIV.image = UIImage(named: "intro_bg")
        bgIV.contentMode = UIViewContentMode.scaleAspectFill
        return bgIV
    }()
    let logo : UIImageView = {
        let logoIV = UIImageView()
        logoIV.translatesAutoresizingMaskIntoConstraints = true
        logoIV.image = UIImage(named: "logo")
        logoIV.contentMode = UIViewContentMode.scaleAspectFit
        return logoIV
    }()
    let createWalletButton: UIButton = {
        let button = Button(size: .normal, style: .solid)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("welcome.createWallet.button.title", value: "CREATE WALLET", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        return button
    }()
    let importWalletButton: UIButton = {
        let importWalletButton = Button(size: .normal, style: .border)
        importWalletButton.translatesAutoresizingMaskIntoConstraints = false
        importWalletButton.setTitle(NSLocalizedString("welcome.importWallet.button.title", value: "IMPORT WALLET", comment: ""), for: .normal)
        importWalletButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        importWalletButton.accessibilityIdentifier = "import-wallet"
        return importWalletButton
    }()
    let pages: [OnboardingPageViewModel] = [
        OnboardingPageViewModel(
            title: NSLocalizedString("welcome.privateAndSecure.label.title", value: "Private & Secure", comment: ""),
            subtitle: NSLocalizedString("welcome.privateAndSecure.label.description", value: "Private keys never leave your device.", comment: ""),
            image: R.image.onboarding_lock()!
        ),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        
        bg.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            logo.frame = CGRect(x: view.frame.width/2-90, y: 80, width: 180, height: 100)
        }else {
            logo.frame = CGRect(x: view.frame.width/2-90, y: 60, width: 180, height: 100)
        }
        
        view.addSubview(bg)
        view.addSubview(logo)


        viewModel.numberOfPages = pages.count
      
        view.addSubview(collectionViewController.view)
        let stackView = UIStackView(arrangedSubviews: [
            createWalletButton,
            importWalletButton,
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.backgroundColor = UIColor.clear
        stackView.spacing = 15
        view.addSubview(stackView)

        collectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        collectionViewController.view.backgroundColor = UIColor.clear
        
        NSLayoutConstraint.activate([
            collectionViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            collectionViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: collectionViewController.view.centerYAnchor, constant: 180),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 240),


            createWalletButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            createWalletButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

            importWalletButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            importWalletButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])

        createWalletButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        importWalletButton.addTarget(self, action: #selector(importFlow), for: .touchUpInside)

        configure(viewModel: viewModel)
    }

    func configure(viewModel: WelcomeViewModel) {
        title = NSLocalizedString("Welcome", value: "Welcome", comment: "")
        view.backgroundColor = viewModel.backgroundColor
    }

    @IBAction func start() {
        delegate?.didPressCreateWallet(in: self)
    }

    @IBAction func importFlow() {
        delegate?.didPressImportWallet(in: self)
    }
}
