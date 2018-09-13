import UIKit

protocol ReceiveInteractorInput: class {
    func getUser() -> User
    func getBalance()
}
