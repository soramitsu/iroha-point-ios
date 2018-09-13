import UIKit

class TransactionHistoryAssembly {
    static func configure(_ controller: HistoryTableViewController) {
        let irohaService = IrohaService()
        let userDefaults = UserDefalultsStorage()
        let keychain = KeychainStorage(service: AppConfig.storage.keychain)
        let interactor = HistoryInteractor(irohaService: irohaService,
                                           userDefaults: userDefaults,
                                           keychain: keychain)
        irohaService.interactor = interactor
        interactor.controller = controller
        controller.interactor = interactor
    }
}
