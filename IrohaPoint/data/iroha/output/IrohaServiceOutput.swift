import UIKit

protocol IrohaServiceOutput: class {
    func accountIsAlreadyExist(for user: User)
    func accountIsNew(for user: User)
    func didGet(_ tokensAmount: Int)
    func didNotGetTokensAmount()
    func didGet(_ transactionHistory: [TransactionHistory])
    func didSendTokens()
    func noConnection()
}

extension IrohaServiceOutput {
    func accountIsAlreadyExist(for user: User) {}
    func accountIsNew(for user: User) {}
    func didGet(_ tokensAmount: Int) {}
    func didNotGetTokensAmount() {}
    func didGet(_ transactionHistory: [TransactionHistory]) {}
    func didSendTokens() {}
    func noConnection() {}
}
