// Copyright SIX DAY LLC. All rights reserved.

import Foundation
import TrustCore

enum BranchEventName: String {
    case newToken
}

enum BranchEvent {
    case newToken(Address)

    var params: [String: String] {
        switch self {
        case .newToken(let address):
            return [
                "contract": address.eip55String,
                "event": BranchEventName.newToken.rawValue,
            ]
        }
    }
}

extension BranchEvent: Equatable {
    static func == (lhs: BranchEvent, rhs: BranchEvent) -> Bool {
        switch (lhs, rhs) {
        case (let .newToken(lhs), let .newToken(rhs)):
            return lhs == rhs
        case (_, .newToken):
            return false
        }
    }
}
