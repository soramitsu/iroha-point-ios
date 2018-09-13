import UIKit

protocol RegistrationInteractorOutput: class {
    func didRegisterUser()
    func didGet(errorMessage: String)
    func noConnection()
}
