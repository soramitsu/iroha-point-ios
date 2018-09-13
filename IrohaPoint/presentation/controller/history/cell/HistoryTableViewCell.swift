import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var roundView: SoraButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
//        cardView.layer.cornerRadius = 8
//        cardView.layer.shadowOpacity = 0.10
//        cardView.layer.shadowColor = UIColor.black.cgColor
//        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        cardView.layer.shadowRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {}

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        UIView.animate(withDuration: 0.2) {
//            self.cardView.transform = highlighted ? CGAffineTransform(scaleX: 0.90, y: 0.90) : CGAffineTransform.identity
//            self.cardView.layer.shadowOpacity = highlighted ? 0.1 : 0.2
//        }
    }

    func set(_ transactionHistory: TransactionHistory) {
        if transactionHistory.isIncoming {
            let receiveImage = UIImage(named: "receive")?.withRenderingMode(.alwaysTemplate)
            roundView.setImage(receiveImage, for: .normal)
            roundView.tintColor = .green
            titleLabel.text = transactionHistory.fromUser.username
            amountLabel.text = "+\(transactionHistory.amount) IRH"
        } else {
            let sendImage = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
            roundView.setImage(sendImage, for: .normal)
            roundView.tintColor = .red
            titleLabel.text = transactionHistory.toUser.username
            amountLabel.text = "-\(transactionHistory.amount) IRH"
        }
        timeLabel.text = transactionHistory.time
    }
}
