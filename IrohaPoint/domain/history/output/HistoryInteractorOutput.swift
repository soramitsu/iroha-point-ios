import UIKit

protocol HistoryInteractorOutput: class {
    func didGet(_ transactionHistory: [TransactionHistory])
}
