import Foundation

class UserDefalultsStorage {

    private var userDefaults: UserDefaults! = UserDefaults.standard

    init() {}

    init(suiteName: String) {
        userDefaults = UserDefaults(suiteName: suiteName)
    }
}

extension UserDefalultsStorage: KeyValueStorage {

    func create<T>(value: T, key: StorageData) throws where T: NSCoding {
        let userData = NSKeyedArchiver.archivedData(withRootObject: value)
        userDefaults.set(userData, forKey: key.string)
    }

    func readValue<T>(for key: StorageData) throws -> T? where T: NSCoding {
        guard let loadedData = userDefaults.value(forKey: key.string) else {
            return nil
        }
        if let loadedClass = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? T {
            return loadedClass
        }
        return nil
    }

    func update(value: Any, key: StorageData) throws {
        let userData = NSKeyedArchiver.archivedData(withRootObject: value)
        userDefaults.set(userData, forKey: key.string)
    }

    func deleteValue(for key: StorageData) throws {

    }
}
