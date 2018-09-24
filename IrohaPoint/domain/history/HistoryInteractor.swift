import UIKit

class HistoryInteractor {

    var controller: HistoryInteractorOutput!

    private var irohaService: IrohaServiceInput!
    private var userDefaults: KeyValueStorage!
    private var keychain: KeyValueStorage!

    init(irohaService: IrohaServiceInput,
         userDefaults: KeyValueStorage,
         keychain: KeyValueStorage) {
        self.irohaService = irohaService
        self.userDefaults = userDefaults
        self.keychain = keychain
    }
}

extension HistoryInteractor: HistoryInteractorInput {
    func getTransactionHistory() {
        var user = User(username: "")
        var userKeypair = Keypair(publicKey: "", privateKey: "")
        do {
            guard let userKeypairFromKeychain: Keypair = try keychain.readValue(for: StorageData.keypair),
                let userFromKeychain: User = try keychain.readValue(for: StorageData.appUser) else {
                return
            }
            userKeypair = userKeypairFromKeychain
            user = userFromKeychain
        } catch {

        }
        DispatchQueue.global().async {
            self.irohaService.getTransactionHistory(for: user, signedWith: userKeypair)
        }
    }
}


extension HistoryInteractor: IrohaServiceOutput {
    func didGet(_ transactionHistory: [TransactionHistory]) {
        DispatchQueue.main.async {
            self.controller.didGet(transactionHistory)
        }
    }
}

