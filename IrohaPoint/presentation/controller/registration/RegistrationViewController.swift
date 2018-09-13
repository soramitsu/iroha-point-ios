import UIKit
import SkyFloatingLabelTextField
import PKHUD

class RegistrationViewController: UIViewController {

    private final var usernameRegex = "^[a-z0-9]{1,32}$"

    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerButton: SoraButton!
    @IBOutlet weak var centerVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!

    var interactor: RegistrationInteractorInput!

    override func viewDidLoad() {
        super.viewDidLoad()
        RegistrationAssembly.configure(self)

        usernameTextField.lineColor = .lightGray
        usernameTextField.selectedLineColor = .black

        usernameTextField.textColor = .black
        usernameTextField.placeholder = "Type username"
        usernameTextField.title = "Your username:"

        usernameTextField.titleColor = .lightGray
        usernameTextField.selectedTitleColor = .black

        usernameTextField.iconColor = .lightGray
        usernameTextField.placeholderColor = .lightGray
        usernameTextField.iconType = .image
        usernameTextField.iconImageView.image = UIImage(named: "new_user")
        usernameTextField.iconMarginLeft = 8
        usernameTextField.iconMarginBottom = 0
        usernameTextField.autocorrectionType = .no
        usernameTextField.delegate = self

        cardView.layer.cornerRadius = 8
        cardView.layer.shadowOpacity = 0.15
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowRadius = 8

        registerButton.setInactive(with: .lightGray)

        observe(keyboardEvents: [.willShow, .willHide])
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func didPressRegisterButton(_ sender: SoraButton) {
        PKHUD.sharedHUD.show()
        HUD.flash(.progress)
        usernameTextField.resignFirstResponder()
        
        guard let username = usernameTextField.text else {
            return
        }

        let user = User(username: username)
        interactor.register(user)
    }
}

extension RegistrationViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let username = usernameTextField.text,
            let textRange = Range(range, in: username) {
            let updatedUsername = username.replacingCharacters(in: textRange,
                                                               with: string)
            if updatedUsername.matches(usernameRegex) {
                usernameTextField.errorMessage = nil
                registerButton.setActive(with: AppDesign.color.MAIN_COLOR)
            } else {
                usernameTextField.errorMessage = "Wrong format"
                registerButton.setInactive(with: .lightGray)
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegistrationViewController: KeyboardObservable {

    func keyboardWillShow(with notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            view.frame.origin.y == 0 else { return }

        var bottomPadding: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomPadding = window!.safeAreaInsets.bottom
        }

        bottomConstraint.constant = keyboardSize.height + bottomPadding + 16
        bottomConstraint.priority = UILayoutPriority(750)
        centerVerticalConstraint.priority = UILayoutPriority(250)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    func keyboardWillHide(with notification: Notification) {
        guard let _ = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        bottomConstraint.constant = 200
        bottomConstraint.priority = UILayoutPriority(250)
        centerVerticalConstraint.priority = UILayoutPriority(750)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

extension RegistrationViewController: RegistrationInteractorOutput {
    func didRegisterUser() {
        PKHUD.sharedHUD.hide()

        let tabBarController = TabBarController()

        UIView.transition(with: UIApplication.shared.keyWindow!,
                          duration: 0.5,
                          options: .transitionFlipFromLeft,
                          animations: {
                            let oldState: Bool = UIView.areAnimationsEnabled
                            UIView.setAnimationsEnabled(false)
                            UIApplication.shared.keyWindow!.rootViewController = tabBarController
                            UIView.setAnimationsEnabled(oldState)
        }, completion: nil)
    }

    func didGet(errorMessage: String) {
        PKHUD.sharedHUD.hide()

        let alertController = UIAlertController(title: "Username was already taken",
                                                message: "Please, choose another username",
                                                preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
            self.dismiss(animated: true)
        })

        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func noConnection() {
        PKHUD.sharedHUD.hide()

        let alertController = UIAlertController(title: "No connection to Iroha Network",
                                                message: "Please, enable internet connection",
                                                preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
            self.dismiss(animated: true)
        })

        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
