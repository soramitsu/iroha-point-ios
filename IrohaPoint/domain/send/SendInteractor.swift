import UIKit

class SendInteractor {
    private var irohaService: IrohaServiceInput!
    private var userDefaults: KeyValueStorage!
    private var keychain: KeyValueStorage!

    weak var controller: SendInteractorOutput!

    init(irohaService: IrohaServiceInput,
         userDefaults: KeyValueStorage,
         keychain: KeyValueStorage) {
        self.irohaService = irohaService
        self.userDefaults = userDefaults
        self.keychain = keychain
    }

    var tokensAmount: String!
}

extension SendInteractor: SendInteractorInput {
    func getUser() -> User {
        do {
            guard let user: User = try keychain.readValue(for: StorageData.appUser) else {
                return User(username: "")
            }
            return user
        } catch {

        }
        return User(username: "")
    }

    func getBalance(for user: User) {
        var userKeypair = Keypair(publicKey: "", privateKey: "")
        do {
            guard let userKeypairFromKeychain: Keypair = try keychain.readValue(for: StorageData.keypair) else {
                return
            }
            userKeypair = userKeypairFromKeychain
        } catch {

        }
        DispatchQueue.global().async {
            self.irohaService.getTokensAmount(for: user, signedWith: userKeypair)
        }
    }

    func sendTokens(_ tokensAmount: String, from fromUser: User, to toUser: User) {
        self.tokensAmount = tokensAmount
        DispatchQueue.global().async {
            self.irohaService.checkIfExists(toUser)
        }
    }
}

extension SendInteractor: IrohaServiceOutput {
    func accountIsAlreadyExist(for user: User) {
        var userKeypair = Keypair(publicKey: "", privateKey: "")
        var fromUser = User(username: "")
        do {
            guard
                let fromUserFromKeychain: User = try keychain.readValue(for: StorageData.appUser),
                let userKeypairFromKeychain: Keypair = try keychain.readValue(for: StorageData.keypair) else {
                return
            }
            userKeypair = userKeypairFromKeychain
            fromUser = fromUserFromKeychain
        } catch {
            return
        }
        irohaService.send(Int(tokensAmount)!, from: fromUser, signedWith: userKeypair, to: user)
    }

    func accountIsNew(for user: User) {
        DispatchQueue.main.async {
            self.controller.didGet("Account is not exist")
        }
    }

    func didSendTokens() {
        DispatchQueue.main.async {
            self.controller.didSendTokens()
        }
    }

    func didGet(_ tokensAmount: Int) {
        DispatchQueue.main.async {
            self.controller.didGet(tokensAmount)
        }
    }

    func didNotGetTokensAmount() {
        DispatchQueue.main.async {
            self.controller.didNotGetTokensAmount()
        }
    }

    func noConnection() {
        DispatchQueue.main.async {
            self.controller.didNotGetTokensAmount()
        }
    }
}
