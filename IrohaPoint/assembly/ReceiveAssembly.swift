import UIKit

class ReceiveAssembly: NSObject {
    static func configure(_ controller: ReceiveTableViewController) {
        let irohaService = IrohaService()
        let keychain = KeychainStorage(service: AppConfig.storage.keychain)
        let interactor = ReceiveInteractor(keychain: keychain, irohaService: irohaService)
        controller.interactor = interactor
        interactor.controller = controller
        irohaService.interactor = interactor
    }
}
