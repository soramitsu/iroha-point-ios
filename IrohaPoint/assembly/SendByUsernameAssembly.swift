import UIKit

class SendByUsernameAssembly {
    static func configure(_ controller: SendByUsernameViewController) {
        let irohaService = IrohaService()
        let userDefaults = UserDefalultsStorage()
        let keychain = KeychainStorage(service: AppConfig.storage.keychain)
        let interactor = SendInteractor(irohaService: irohaService,
                                        userDefaults: userDefaults,
                                        keychain: keychain)
        irohaService.interactor = interactor
        interactor.controller = controller
        controller.interactor = interactor
    }
}
