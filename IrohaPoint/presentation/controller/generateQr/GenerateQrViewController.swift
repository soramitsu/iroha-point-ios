import UIKit
import SkyFloatingLabelTextField

class GenerateQrViewController: UIViewController {

    private final var amountRegex = "^[0-9]{1,10}$"

    var user: User!
    var tokensAmount: Int!

    @IBOutlet weak var cardView: UIView!

    @IBOutlet weak var amountTextField: SkyFloatingLabelTextFieldWithIcon!

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var genetateQRCodeButton: SoraButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Generate QR-code"

        amountTextField.textColor = .black
        amountTextField.placeholder = "Amount"
        amountTextField.title = "Amount to receive:"

        amountTextField.titleColor = .lightGray
        amountTextField.selectedTitleColor = .black

        amountTextField.iconColor = .lightGray
        amountTextField.placeholderColor = .lightGray
        amountTextField.iconType = .image
        amountTextField.iconImageView.image = UIImage(named: "coin")
        amountTextField.iconMarginLeft = 8
        amountTextField.iconMarginBottom = 0
        amountTextField.autocorrectionType = .no
        amountTextField.delegate = self
        amountTextField.keyboardType = .numberPad

        let keyboardToolbar = KeyboardToolbar()
        keyboardToolbar.keyboardDelegate = self
        amountTextField.inputAccessoryView = keyboardToolbar

        cardView.layer.cornerRadius = 8
        cardView.layer.shadowOpacity = 0.15
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowRadius = 8

        observe(keyboardEvents: [.willShow, .willHide])

        genetateQRCodeButton.setInactive(with: .lightGray)
    }

    @IBAction func didPressGenerateButton(_ sender: SoraButton) {
        let generatedVC = GeneratedQrViewController()
        generatedVC.user = user
        generatedVC.tokensAmount = amountTextField.text
        let generatedQrNC = UINavigationController(rootViewController: generatedVC)
        present(generatedQrNC, animated: true)
    }
}

extension GenerateQrViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let amount = amountTextField.text,
            let textRange = Range(range, in: amount) {
            let updatedAmount = amount.replacingCharacters(in: textRange,
                                                               with: string)
            if updatedAmount.matches(amountRegex) {
                amountTextField.errorMessage = nil
                genetateQRCodeButton.setActive(with: AppDesign.color.MAIN_COLOR)
            } else {
                amountTextField.errorMessage = "Wrong format"
                genetateQRCodeButton.setInactive(with: .lightGray)
            }
        }
        return true
    }
}

extension GenerateQrViewController: KeyboardObservable {

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

extension GenerateQrViewController: KeyboardToolbarDelegate {
    func didPressDoneButton() {
        view.endEditing(true)
    }
}
