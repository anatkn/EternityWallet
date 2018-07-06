// Copyright SIX DAY LLC. All rights reserved.

import UIKit

class SplashView: UIView {
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = Colors.darkPurple
        let logoImageView = UIImageView(image: R.image.logo())
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
