import UIKit
import SkyFloatingLabelTextField
import PKHUD

class SendByUsernameViewController: UIViewController {

    private final var usernameRegex = "^[a-z0-9]{1,32}$"
    private final var amountRegex = "^[0-9]{1,10}$"

    var interactor: SendInteractorInput!

    var user: User!
    var currentTokensAmount: Int!
    var tokensAmount: String?

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var amountTextField: SkyFloatingLabelTextFieldWithIcon!

    @IBOutlet weak var sendButton: SoraButton!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SendByUsernameAssembly.configure(self)

        title = "Type Username"

        usernameTextField.lineColor = .lightGray
        usernameTextField.selectedLineColor = .black

        usernameTextField.textColor = .black
        usernameTextField.placeholder = "Username"
        usernameTextField.title = "User to send tokens:"

        usernameTextField.titleColor = .lightGray
        usernameTextField.selectedTitleColor = .black

        usernameTextField.iconColor = .lightGray
        usernameTextField.placeholderColor = .lightGray
        usernameTextField.iconType = .image
        usernameTextField.iconImageView.image = UIImage(named: "users")
        usernameTextField.iconMarginLeft = 8
        usernameTextField.iconMarginBottom = 0
        usernameTextField.autocorrectionType = .no
        usernameTextField.delegate = self

        let keyboardToolbar = KeyboardToolbar()
        keyboardToolbar.keyboardDelegate = self
        usernameTextField.inputAccessoryView = keyboardToolbar

        usernameTextField.lineColor = .lightGray
        usernameTextField.selectedLineColor = .black

        amountTextField.textColor = .black
        amountTextField.placeholder = "Amount"
        amountTextField.title = "Amount to send:"

        amountTextField.titleColor = .lightGray
        amountTextField.selectedTitleColor = .black

        amountTextField.iconColor = .lightGray
        amountTextField.placeholderColor = .lightGray
        amountTextField.iconType = .image
        amountTextField.iconImageView.image = UIImage(named: "coin")
        amountTextField.iconMarginLeft = 8
        amountTextField.iconMarginBottom = 0
        amountTextField.autocorrectionType = .no
        amountTextField.keyboardType = .numberPad
        amountTextField.delegate = self

        amountTextField.inputAccessoryView = keyboardToolbar

        cardView.layer.cornerRadius = 8
        cardView.layer.shadowOpacity = 0.15
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowRadius = 8

        observe(keyboardEvents: [.willShow, .willHide])

        sendButton.setInactive(with: .lightGray)

        guard
            let username = user?.username,
            let amount = tokensAmount else {
                return
        }

        usernameTextField.text = username
        amountTextField.text = amount

        if currentTokensAmount > Int(amount)! {
            sendButton.setActive(with: AppDesign.color.MAIN_COLOR)
        } else {
            amountTextField.errorMessage = "Not enought tokens"
            sendButton.setInactive(with: .lightGray)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func didPressSendButton(_ sender: SoraButton) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.endEditing(true)

        PKHUD.sharedHUD.show()
        HUD.flash(.progress)

        guard
            let tokensAmount = amountTextField.text,
            let toUsername = usernameTextField.text else {
                return
        }

        interactor.sendTokens(tokensAmount,
                              from: user!,
                              to: User(username: toUsername))
    }
}

extension SendByUsernameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        var updatedUsername = usernameTextField.text ?? ""
        var updatedAmount = amountTextField.text ?? ""

        if textField == usernameTextField {
            if let username = usernameTextField.text,
                let textRange = Range(range, in: username) {
                updatedUsername = username.replacingCharacters(in: textRange,
                                                               with: string)
            }
        }

        if textField == amountTextField {
            if let amount = amountTextField.text,
                let textRange = Range(range, in: amount) {
                updatedAmount = amount.replacingCharacters(in: textRange,
                                                       with: string)
            }
        }

        if updatedAmount.matches(amountRegex) {
            if currentTokensAmount < Int(updatedAmount)! {
                amountTextField.errorMessage = "Not enought tokens"
            } else {
                amountTextField.errorMessage = nil
            }
        } else {
            amountTextField.errorMessage = "Wrong format"
        }

        if updatedUsername.matches(usernameRegex) {
            usernameTextField.errorMessage = nil
        } else {
            usernameTextField.errorMessage = "Wrong format"
        }

        if updatedUsername.matches(usernameRegex) &&
            updatedAmount.matches(amountRegex) &&
            currentTokensAmount > Int(updatedAmount)! {
            sendButton.setActive(with: AppDesign.color.MAIN_COLOR)
        } else {
            sendButton.setInactive(with: .lightGray)
        }


        return true
    }
}

extension SendByUsernameViewController: KeyboardObservable {

    func keyboardWillShow(with notification: Notification) {
        let origin = navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            view.frame.origin.y == origin else { return }

        var bottomPadding: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            bottomPadding = window!.safeAreaInsets.bottom
        }

        navigationController?.setNavigationBarHidden(true, animated: true)
        bottomConstraint.constant = keyboardSize.height + bottomPadding + 16
        bottomConstraint.priority = UILayoutPriority(750)
        topConstraint.priority = UILayoutPriority(250)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    func keyboardWillHide(with notification: Notification) {
        guard let _ = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        navigationController?.setNavigationBarHidden(false, animated: true)
        bottomConstraint.constant = 200
        bottomConstraint.priority = UILayoutPriority(250)
        topConstraint.priority = UILayoutPriority(750)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

extension SendByUsernameViewController: SendInteractorOutput {
    func didGet(_ errorMessage: String) {
        PKHUD.sharedHUD.hide()
        let alertController = UIAlertController(title: "Username does not exist",
                                                message: "Please, choose another username to send tokens",
                                                preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
            self.dismiss(animated: true)
        })

        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func didSendTokens() {
        PKHUD.sharedHUD.hide()
        navigationController?.popToRootViewController(animated: true)
    }
}

extension SendByUsernameViewController: KeyboardToolbarDelegate {
    func didPressDoneButton() {
        view.endEditing(true)
    }
}
