import UIKit

class ReceiveInteractor {
    var controller: ReceiveInteractorOutput!

    private var keychain: KeyValueStorage!
    private var irohaService: IrohaServiceInput!

    init(keychain: KeyValueStorage,
         irohaService: IrohaServiceInput) {
        self.keychain = keychain
        self.irohaService = irohaService
    }
}

extension ReceiveInteractor: ReceiveInteractorInput {
    func getBalance() {
        var user = User(username: "")
        var userKeypair = Keypair(publicKey: "", privateKey: "")
        do {
            guard
                let userKeypairFromKeychain: Keypair = try keychain.readValue(for: StorageData.keypair),
                let userFromKeychain: User = try keychain.readValue(for: StorageData.appUser) else {
                return
            }
            userKeypair = userKeypairFromKeychain
            user = userFromKeychain
        } catch {

        }
        DispatchQueue.global().async {
            self.irohaService.getTokensAmount(for: user, signedWith: userKeypair)
        }
    }

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
}

extension ReceiveInteractor: IrohaServiceOutput {
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



