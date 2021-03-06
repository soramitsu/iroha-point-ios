import UIKit

class RegistrationAssembly {

    static func configure(_ controller: RegistrationViewController) {
        let irohaService = IrohaService()
        let userDefaults = UserDefalultsStorage()
        let keychain = KeychainStorage(service: AppConfig.storage.keychain)
        let interactor = RegistrationInteractor(irohaService: irohaService,
                                                userDefaults: userDefaults,
                                                keychain: keychain)
        irohaService.interactor = interactor
        interactor.controller = controller
        controller.interactor = interactor
    }
}
