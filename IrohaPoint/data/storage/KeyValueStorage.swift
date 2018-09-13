import UIKit

protocol KeyValueStorage: class {
    func create<T: NSCoding>(value: T, key: StorageData) throws
    func readValue<T: NSCoding>(for key: StorageData) throws -> T?
    func update(value: Any, key: StorageData) throws
    func deleteValue(for key: StorageData) throws
}
