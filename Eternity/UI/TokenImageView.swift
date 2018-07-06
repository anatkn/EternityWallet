// Copyright SIX DAY LLC. All rights reserved.

import UIKit

class TokenImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = false
        contentMode = .scaleAspectFit
        clipsToBounds = true
    }
}
