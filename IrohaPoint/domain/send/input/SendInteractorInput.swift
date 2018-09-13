import UIKit

protocol SendInteractorInput: class {
    func getUser() -> User
    func getBalance(for user: User)
    func sendTokens(_ tokensAmount: String,
                    from fromUser: User,
                    to toUser: User)
}
