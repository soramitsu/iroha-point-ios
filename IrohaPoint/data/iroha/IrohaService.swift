import UIKit
import SwiftyIroha

class IrohaService {

    var interactor: IrohaServiceOutput!

    private final let ADMIN_ACCOUNT_ID = AppConfig.irohaConfig.adminAccountId
    private final let ADMIN_PUBLIC_KEY = AppConfig.irohaConfig.adminPublicKey
    private final let ADMIN_PRIVATE_KEY = AppConfig.irohaConfig.adminPrivateKey
    private final let DOMAIN_ID = AppConfig.irohaConfig.domainId
    private final let ASSET_ID = AppConfig.irohaConfig.assetId
}

extension IrohaService: IrohaServiceInput {

    func generateNewKeypair() -> Keypair {
        let keypair = IrohaModelCrypto().generateKeypair()
        return Keypair(publicKey: keypair.getPublicKey().getValue(),
                       privateKey: keypair.getPrivateKey().getValue())
    }

    func checkIfExists(_ user: User) {
        let adminPublicKey = IrohaPublicKey(value: ADMIN_PUBLIC_KEY)
        let adminPrivateKey = IrohaPrivateKey(value: ADMIN_PRIVATE_KEY)
        let adminKeypair = IrohaKeypair(publicKey: adminPublicKey,
                                        privateKey: adminPrivateKey)
        let irohaQueryBuilder = IrohaQueryBuilder()
        do {
            let unsignedQuery = try irohaQueryBuilder
                .creatorAccountId(ADMIN_ACCOUNT_ID + "@" + DOMAIN_ID)
                .createdTime(Date())
                .queryCounter(1)
                .getAccount(byAccountId: user.username + "@" + DOMAIN_ID)
                .build()

            LOGGER.userInfo(logClass: self,
                            methodName: #function,
                            description: "Sending transaction for checking if user with username \(user.username) exists",
                data: [0 : ("queryName", "getAccountByAccountId"),
                       1 : ("creatorAccountId", ADMIN_ACCOUNT_ID + "@" + DOMAIN_ID),
                       2 : ("username", user.username),
                       3 : ("domainId", DOMAIN_ID),
                       4 : ("publicKey", adminKeypair.getPublicKey().getValue())])

            try IrohaTransactionSender().sendToIroha(unsignedQuery, signedWith: adminKeypair) { response, error in
                if error != nil {
                    interactor.noConnection()
                    return
                }

                if (response.errorResponse.reason != .noAccount) {
                    interactor.accountIsAlreadyExist(for: user)
                } else {
                    interactor.accountIsNew(for: user)
                }
            }
        } catch {
            LOGGER.systemError(logClass: self,
                               methodName: #function,
                               description: "Sending transaction for checking if user with username \(user.username) exists failed",
                message: "\(error)")
        }
    }

    func register(_ newUser: User, with userKeypair: Keypair) {
        let adminPublicKey = IrohaPublicKey(value: ADMIN_PUBLIC_KEY)
        let adminPrivateKey = IrohaPrivateKey(value: ADMIN_PRIVATE_KEY)
        let adminKeypair = IrohaKeypair(publicKey: adminPublicKey,
                                        privateKey: adminPrivateKey)
        let irohaTransactionBuilder = IrohaTransactionBuilder()
        let userKeypairIroha = toIrohaKeypair(userKeypair)
        do {
            let unsignedTransaction = try irohaTransactionBuilder
                .creatorAccountId(ADMIN_ACCOUNT_ID + "@" + DOMAIN_ID)
                .createdTime(Date())
                .createAccount(withAccountName: newUser.username,
                               withDomainId: DOMAIN_ID,
                               withPublicKey: userKeypairIroha.getPublicKey())
                .build()

            LOGGER.userInfo(logClass: self,
                            methodName: #function,
                            description: "Sending transaction for registrating new user",
                            data: [0 : ("creatorAccountId", ADMIN_ACCOUNT_ID + "@" + DOMAIN_ID),
                                   1 : ("companyName", newUser.username),
                                   2 : ("domainId", DOMAIN_ID),
                                   3 : ("publicKey", userKeypairIroha.getPublicKey().getValue())])

            try IrohaTransactionSender().sendToIroha(unsignedTransaction, signedWith: adminKeypair) {
                add(100, to: newUser)
            }

        } catch {
            LOGGER.systemError(logClass: self,
                               methodName: #function,
                               description: "Sending transaction for registrating new company failed",
                               message: "\(error)")
        }
    }

    func send(_ tokensAmount: Int,
              from fromUser: User,
              signedWith fromUserKeypair: Keypair,
              to toUser: User) {
        let irohaTransactionBuilder = IrohaTransactionBuilder()
        let fromUserKeypairIroha = toIrohaKeypair(fromUserKeypair)
        do {
            let createdTime = Date()
            let unsignedTransaction = try irohaTransactionBuilder
                .creatorAccountId(fromUser.username + "@" + DOMAIN_ID)
                .createdTime(createdTime)
                .transferAsset(fromAccountId: fromUser.username + "@" + DOMAIN_ID,
                               toAccountId: toUser.username + "@" + DOMAIN_ID,
                               withAssetId: ASSET_ID + "#" + DOMAIN_ID,
                               withDescription: "tokens",
                               withAmount: "\(tokensAmount)")
                .build()

            LOGGER.userInfo(logClass: self,
                            methodName: #function,
                            description: "Sending transaction for adding tokens to created user",
                            data: [0 : ("transactionName", "transferAsset"),
                                   1 : ("creatorAccountId", fromUser.username + "@" + DOMAIN_ID),
                                   2 : ("fromAccountId", fromUser.username + "@" + DOMAIN_ID),
                                   3 : ("toAccountId", toUser.username + "@" + DOMAIN_ID),
                                   4 : ("createdTime", String(createdTime.timeIntervalSince1970)),
                                   5 : ("assetId", ASSET_ID + "#" + DOMAIN_ID),
                                   6 : ("description", "tokens"),
                                   7 : ("amount", "\(tokensAmount)"),
                                   8 : ("publicKey", fromUserKeypair.publicKey)])

            try IrohaTransactionSender().sendToIroha(unsignedTransaction, signedWith: fromUserKeypairIroha) {
                interactor.didSendTokens()
            }
        } catch {
            LOGGER.systemError(logClass: self,
                               methodName: #function,
                               description: "Sending transaction for adding tokens to created user failed",
                               message: "\(error)")
        }
    }

    func add(_ tokensAmount: Int, to user: User) {
        let publicKey = IrohaPublicKey(value: ADMIN_PUBLIC_KEY)
        let privateKey = IrohaPrivateKey(value: ADMIN_PRIVATE_KEY)
        let adminKeypair = IrohaKeypair(publicKey: publicKey,
                                        privateKey: privateKey)
        let irohaTransactionBuilder = IrohaTransactionBuilder()
        do {
            let createdTime = Date()
            let unsignedTransaction = try irohaTransactionBuilder
                .creatorAccountId(ADMIN_ACCOUNT_ID + "@" + DOMAIN_ID)
                .createdTime(createdTime)
                .addAssetQuantity(withAccountId: ADMIN_ACCOUNT_ID + "@" + DOMAIN_ID,
                                  withAssetsId: ASSET_ID + "#" + DOMAIN_ID,
                                  withAmount: "\(tokensAmount)")
                .transferAsset(fromAccountId: ADMIN_ACCOUNT_ID + "@" + DOMAIN_ID,
                               toAccountId: user.username + "@" + DOMAIN_ID,
                               withAssetId: ASSET_ID + "#" + DOMAIN_ID,
                               withDescription: "tokens",
                               withAmount: "\(tokensAmount)")
                .build()

            LOGGER.userInfo(logClass: self,
                            methodName: #function,
                            description: "Sending transaction for adding tokens to created user",
                            data: [0 : ("creatorAccountId", ADMIN_ACCOUNT_ID + "@" + DOMAIN_ID),
                                   1 : ("domainId", DOMAIN_ID),
                                   2 : ("assetId", ASSET_ID),
                                   3 : ("createdTime", String(createdTime.timeIntervalSince1970)),
                                   4 : ("username", user.username),
                                   5 : ("amount", "\(tokensAmount)"),
                                   6 : ("publicKey", adminKeypair.getPublicKey().getValue())])

            try IrohaTransactionSender().sendToIroha(unsignedTransaction, signedWith: adminKeypair) {
                // userDefaults.addAccountAsset(cargo.name)
                // interactor.didRegister(company)
            }
        } catch {
            LOGGER.systemError(logClass: self,
                               methodName: #function,
                               description: "Sending transaction for adding tokens to created user failed",
                               message: "\(error)")
        }
    }

    func getTransactionHistory(for user: User, signedWith keypair: Keypair) {
        let irohaQueryBuilder = IrohaQueryBuilder()
        let irohaKeypair = toIrohaKeypair(keypair)
        let createdTime = Date()
        do {
            let unsignedQuery = try irohaQueryBuilder
                .creatorAccountId(user.username  + "@" + DOMAIN_ID)
                .createdTime(createdTime)
                .queryCounter(1)
                .getAccountAssetsTransactions(forAccountId: user.username  + "@" + DOMAIN_ID,
                                              withAssetId: ASSET_ID + "#" + DOMAIN_ID)
                .build()

            LOGGER.userInfo(logClass: self,
                            methodName: #function,
                            description: "Sending query for getting all account asset transactions",
                            data: [0 : ("queryCommand", "getAccountAssetsTransactions"),
                                   1 : ("queryCreatorAccountId", user.username  + "@" + DOMAIN_ID),
                                   2 : ("createdDate", String(createdTime.timeIntervalSince1970)),
                                   3 : ("queryCounter", "\(1)"),
                                   4 : ("forAccountId", user.username  + "@" + DOMAIN_ID),
                                   5 : ("withAssetId", ASSET_ID + "#" + DOMAIN_ID)])

            try IrohaTransactionSender().sendToIroha(unsignedQuery, signedWith: irohaKeypair) { response, error in
                if error != nil {
                    interactor.noConnection()
                    return
                }

                var transactionHistoryList = [TransactionHistory]()

                let transactions = response.transactionsResponse.transactions.sorted(by: {
                    $0.payload.createdTime > $1.payload.createdTime
                })

                for transaction in transactions
                    where transaction.payload.commands.first!.transferAsset.destAccountID != "" {
                        let fromUsername = transaction.payload.commands.first!.transferAsset.srcAccountID
                        var fromUsernameArr = fromUsername.components(separatedBy: "@")
                        let toUsername = transaction.payload.commands.first!.transferAsset.destAccountID
                        var toUsernameArr = toUsername.components(separatedBy: "@")
                        let fromUser = User(username: fromUsernameArr[0])
                        let toUser = User(username: toUsernameArr[0])
                        let amount =
                        "\(transaction.payload.commands.first!.transferAsset.amount.value.fourth)"
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd MMMM yyyy"
                        let time =
                            dateFormatter.string(from: NSDate(timeIntervalSince1970: TimeInterval(transaction.payload.createdTime / 1000)) as Date)
                        var isIncoming = false
                        if toUser.username == user.username {
                            isIncoming = true
                        }
                        let transactionHistory = TransactionHistory(toUser: toUser,
                                                                    fromUser: fromUser,
                                                                    amount: amount,
                                                                    time: time,
                                                                    isIncoming: isIncoming)
                        transactionHistoryList.append(transactionHistory)
                }

                interactor.didGet(transactionHistoryList)
            }
        } catch {
            LOGGER.systemError(logClass: self,
                               methodName: #function,
                               description: "Sending query for getting history failed",
                               message: "\(error)")
        }
    }

    func getTokensAmount(for user: User, signedWith keypair: Keypair) {
        let irohaQueryBuilder = IrohaQueryBuilder()
        let publicKey = IrohaPublicKey(value: ADMIN_PUBLIC_KEY)
        let privateKey = IrohaPrivateKey(value: ADMIN_PRIVATE_KEY)
        let adminKeypair = IrohaKeypair(publicKey: publicKey,
                                        privateKey: privateKey)
        var tokensAmount = 0
        do {
            let unsignedQuery = try irohaQueryBuilder
                .creatorAccountId(ADMIN_ACCOUNT_ID + "@" + DOMAIN_ID)
                .createdTime(Date())
                .queryCounter(1)
                .getAccountAssets(forAccountId: user.username + "@" + DOMAIN_ID)
                .build()

            try IrohaTransactionSender().sendToIroha(unsignedQuery, signedWith: adminKeypair) { response, error in
                if error != nil {
                    interactor.noConnection()
                    return
                }
                
                guard let accountAsset = response.accountAssetsResponse.accountAssets.first else {
                    interactor.didNotGetTokensAmount()
                    return
                }

                tokensAmount = Int(accountAsset.balance.value.fourth)
                interactor.didGet(tokensAmount)
            }
        } catch {
            LOGGER.systemError(logClass: self,
                               methodName: #function,
                               description: "Sending query for getting amount failed",
                               message: "\(error)")
        }
    }

    // TODO: Move this code somewhere or delete, need refactor
    private func toIrohaKeypair(_ keypair: Keypair) -> IrohaKeypair {
        let publicKey = IrohaPublicKey(value: keypair.publicKey)
        let privateKey = IrohaPrivateKey(value: keypair.privateKey)
        let irohaKeypair = IrohaKeypair(publicKey: publicKey,
                                        privateKey: privateKey)
        return irohaKeypair
    }

    // TODO: Move this code somewhere or delete, need refactor
    private func convertToDictionary(text: String) -> [String: Any] {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return [String: Any]()
    }
}
