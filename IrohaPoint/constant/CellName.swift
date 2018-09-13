import UIKit

enum CellName {
    case accountTableViewCell
    case sendTableViewCell
    case receiveTableViewCell
    case sendTokenTableViewCell
    case historyTableViewCell

    public var string: String {
        switch self {
        case .accountTableViewCell:
            return "AccountTableViewCell"
        case .sendTableViewCell:
            return "SendTableViewCell"
        case .receiveTableViewCell:
            return "ReceiveTableViewCell"
        case .sendTokenTableViewCell:
            return "SendTokenTableViewCell"
        case .historyTableViewCell:
            return "HistoryTableViewCell"
        }
    }
}
