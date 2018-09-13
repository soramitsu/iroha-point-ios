import UIKit
import SDWebImage

protocol AccountSectionHeaderViewDelegate: class {
    func didPressPhotoButton(_ button: SoraButton)
}

class AccountSectionHeaderView: BaseView {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tokensAmountBackgroundView: BalanceView!
    @IBOutlet weak var roundView: SoraButton!

    weak var delegate: AccountSectionHeaderViewDelegate?

    var isLoading: Bool = true {
        didSet {
            tokensAmountBackgroundView.isLoading = isLoading
        }
    }

    var amount: String = "" {
        didSet {
            tokensAmountBackgroundView.amount = amount
        }
    }

    override func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AccountSectionHeaderView",
                        bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.shadowOpacity = 0.15
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowRadius = 8
    }

    @IBAction func didPressPhotoButton(_ sender: SoraButton) {
        delegate?.didPressPhotoButton(sender)
    }

    func set(username: String) {
        usernameLabel.text = username
    }

    func set(_ photo: UIImage) {
        roundView.setImage(photo, for: .normal)
    }
}
