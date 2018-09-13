import UIKit

protocol IrohaServiceInput: class {
    func generateNewKeypair() -> Keypair
    func checkIfExists(_ user: User)
    func register(_ newUser: User, with usersKeypair: Keypair)
    func getTokensAmount(for user: User, signedWith keypair: Keypair)
    func send(_ tokensAmount: Int, from fromUser: User, signedWith fromUserKeypair: Keypair, to toUser: User)
    func getTransactionHistory(for user: User, signedWith keypair: Keypair)
}
