import UIKit
import KeychainAccess

class KeychainStorage {

    private var keychain: Keychain!

    init(service: String) {
        keychain = Keychain(service: service)
    }
}

extension KeychainStorage: KeyValueStorage {
    func create<T: NSCoding>(value: T, key: StorageData) throws {
        let userData = NSKeyedArchiver.archivedData(withRootObject: value)
        try keychain.set(userData, key: key.string)
    }

    func readValue<T: NSCoding>(for key: StorageData) throws -> T? {
        guard let loadedData = try keychain.getData(key.string) else {
            return nil
        }
        if let loadedClass = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? T {
            return loadedClass
        }
        return nil
    }

    func update(value: Any, key: StorageData) throws {
        let userData = NSKeyedArchiver.archivedData(withRootObject: value)
        try keychain.set(userData, key: key.string)
    }

    func deleteValue(for key: StorageData) throws {
        try keychain.remove(key.string)
    }
}
