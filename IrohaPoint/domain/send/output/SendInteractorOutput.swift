import UIKit

protocol SendInteractorOutput: class {
    func didGet(_ tokensAmount: Int)
    func didNotGetTokensAmount()
    func didGet(_ errorMessage: String)
    func didSendTokens()
}

extension SendInteractorOutput {
    func didGet(_ tokensAmount: Int) {}
    func didNotGetTokensAmount() {}
    func didGet(_ errorMessage: String) {}
    func didSendTokens() {}
}
