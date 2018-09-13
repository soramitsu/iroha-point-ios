import UIKit

class Keypair: NSObject, NSCoding {
    var publicKey: String
    var privateKey: String

    init(publicKey: String, privateKey: String) {
        self.publicKey = publicKey
        self.privateKey = privateKey
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(publicKey, forKey: "publicKey")
        aCoder.encode(privateKey, forKey: "privateKey")
    }

    required init?(coder aDecoder: NSCoder) {
        self.publicKey = aDecoder.decodeObject(forKey: "publicKey") as? String ?? ""
        self.privateKey = aDecoder.decodeObject(forKey: "privateKey") as? String ?? ""
    }
}
