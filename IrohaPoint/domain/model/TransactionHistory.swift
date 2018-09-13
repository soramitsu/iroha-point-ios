import UIKit

class TransactionHistory {
    var isIncoming: Bool = true

    var toUser: User
    var fromUser: User
    var amount: String

    var time: String

    init(toUser: User,
         fromUser: User,
         amount: String,
         time: String,
         isIncoming: Bool) {
        self.toUser = toUser
        self.fromUser = fromUser
        self.amount = amount
        self.time = time
        self.isIncoming = isIncoming
    }
}
