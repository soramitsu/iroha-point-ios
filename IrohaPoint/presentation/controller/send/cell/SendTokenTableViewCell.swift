import UIKit

class SendTokenTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: GradientView!
    @IBOutlet weak var roundView: SoraButton!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        roundView.backgroundColor = .white
        cardView.layer.cornerRadius = 8
        cardView.layer.shadowOpacity = 0.15
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {}

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.cardView.transform = highlighted ? CGAffineTransform(scaleX: 0.90, y: 0.90) : CGAffineTransform.identity
            self.cardView.layer.shadowOpacity = highlighted ? 0.1 : 0.2
        }
    }

    func set(backgroundGradient gradient: CAGradientLayer) {
        cardView.set(backgroundGradient: gradient)
    }

    func set(image: UIImage?) {
        roundView.setImage(image, for: .normal)
    }

    func set(title: String) {
        titleLabel.text = title
    }

    func set(info: String) {
        infoLabel.text = info
    }
}
