import UIKit

enum StorageData {

    case keypair
    case appWasLaunchedBefore
    case appUser
    case queryCounter

    public var string: String {
        switch self {
        case .keypair:
            return "co.jp.soramitsu.irohapoint.keypair"
        case .appWasLaunchedBefore:
            return "co.jp.soramitsu.irohapoint.appWasLaunchedBefore"
        case .appUser:
            return "co.jp.soramitsu.irohapoint.appUser"
        case .queryCounter:
            return "co.jp.soramitsu.irohapoint.queryCounter"
        }
    }
}
