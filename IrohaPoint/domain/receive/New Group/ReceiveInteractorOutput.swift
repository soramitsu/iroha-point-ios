import UIKit

protocol ReceiveInteractorOutput: class {
    func didGet(_ tokensAmount: Int)
    func didNotGetTokensAmount()
}
