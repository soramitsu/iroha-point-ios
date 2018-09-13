import UIKit

class RegistrationInteractor {
    private var irohaService: IrohaServiceInput!
    private var userDefaults: KeyValueStorage!
    private var keychain: KeyValueStorage!

    weak var controller: RegistrationInteractorOutput!

    init(irohaService: IrohaServiceInput,
         userDefaults: KeyValueStorage,
         keychain: KeyValueStorage) {
        self.irohaService = irohaService
        self.userDefaults = userDefaults
        self.keychain = keychain
    }
}

extension RegistrationInteractor: RegistrationInteractorInput {
    func register(_ user: User) {
        let userKeypair = irohaService.generateNewKeypair()
        do {
            try keychain.create(value: userKeypair, key: .keypair)
            try keychain.create(value: user, key: .appUser)
        } catch {

        }
        DispatchQueue.global().async {
            self.irohaService.checkIfExists(user)
        }
    }
}

extension RegistrationInteractor: IrohaServiceOutput {
    func accountIsAlreadyExist(for user: User) {
        DispatchQueue.main.async {
            self.controller.didGet(errorMessage: "Sorry, but username \(user.username) is already taken")
        }
    }

    func accountIsNew(for user: User) {
        var userKeypair = Keypair(publicKey: "", privateKey: "")
        do {
            guard let userKeypairFromKeychain: Keypair = try keychain.readValue(for: StorageData.keypair) else {
                return
            }
            userKeypair = userKeypairFromKeychain
        } catch {

        }
        
        DispatchQueue.global().async {
            self.irohaService.register(user, with: userKeypair)
        }

        do {
            try keychain.create(value: "true" as NSString, key: StorageData.appWasLaunchedBefore)
            try userDefaults.create(value: "true" as NSString, key: StorageData.appWasLaunchedBefore)
        } catch {
            
        }

        DispatchQueue.main.async {
            self.controller.didRegisterUser()
        }
    }

    func noConnection() {
        DispatchQueue.main.async {
            self.controller.noConnection()
        }
    }
}

