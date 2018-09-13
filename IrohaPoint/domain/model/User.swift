import UIKit

class User: NSObject, NSCoding {
    var username: String

    init(username: String) {
        self.username = username
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: "username")
    }

    required init?(coder aDecoder: NSCoder) {
        self.username = aDecoder.decodeObject(forKey: "username") as? String ?? ""
    }
}
