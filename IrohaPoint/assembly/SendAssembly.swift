import UIKit

class SendAssembly {
    static func configure(_ controller: SendTableViewController) {
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
