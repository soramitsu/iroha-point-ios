import UIKit

class GeneratedQrViewController: UIViewController {

    @IBOutlet weak var qrCodeImageView: UIImageView!

    var user: User!
    var tokensAmount: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scan me"

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        }

        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .stop,
                            target: self,
                            action: #selector(GeneratedQrViewController.didPressCloseButton))

        qrCodeImageView.image = generateQRCode(from: user.username + "," + tokensAmount)
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }

    @objc func didPressCloseButton() {
        dismiss(animated: true)
    }
}
