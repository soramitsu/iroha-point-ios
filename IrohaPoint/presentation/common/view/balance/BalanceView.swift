import UIKit

@IBDesignable
class BalanceView: BaseView {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tokenIcon: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tokenAmountLabel: UILabel!

    var isLoading: Bool = true {
        didSet {
            if isLoading {
                tokenIcon.isHidden = true
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                tokenAmountLabel.text = "Loading..."
            } else {
                tokenIcon.isHidden = false
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
                tokenAmountLabel.text = ""
            }
        }
    }

    var amount: String = "" {
        didSet {
            tokenAmountLabel.text = amount
        }
    }

    override func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "BalanceView",
                        bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.layer.cornerRadius = 15
        backgroundView.layer.shadowOpacity = 0.15
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundView.layer.shadowRadius = 8
    }
}
