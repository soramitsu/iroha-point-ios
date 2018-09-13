import UIKit
import SwiftyIroha

class IrohaTransactionSender {
    func sendToIroha(_ unsignedTransaction:IrohaUnsignedTransaction,
                     signedWith keypair: IrohaKeypair,
                     completitionHandler: ()->()) throws {

        // Creating helper class for signing unsigned transaction
        let irohaTransactionPreparation = IrohaTransactionPreparation()

        // Signing transaction and getting object which is ready for converting to GRPC object
        let irohaSignedTransactionReadyForConvertingToGRPC =
            irohaTransactionPreparation.sign(unsignedTransaction,
                                             with: keypair)

        // Creating GRPC transaction object from signed transaction
        var irohaGRPCTransaction = Iroha_Protocol_Transaction()

        do {
            try irohaGRPCTransaction.merge(serializedData: irohaSignedTransactionReadyForConvertingToGRPC)

            let transactionJSON = convertToDictionary(text: try irohaGRPCTransaction.payload.jsonString())

            LOGGER.userInfo(logClass: self,
                            methodName: #function,
                            description: "Transaction to Iroha",
                            data: [0 : ("","\(transactionJSON)")])
        }
        catch {
            let nsError = error as NSError
            print("\(nsError.localizedDescription) \n")
        }

        let serviceForSendingTransaction =
            Iroha_Protocol_CommandServiceServiceClient(address: AppConfig.irohaConfig.irohaAddress)

        do {
            let line = "\(#line + 1)"
            let _ = try serviceForSendingTransaction.torii(irohaGRPCTransaction)

            LOGGER.networkSuccess(logClass: self,
                                  methodName: #function,
                                  line: line,
                                  description: "Transaction to Iroha was sucesfully sent",
                                  data: [0:("","")])

            completitionHandler()
        } catch {
            let nsError = error as NSError
            print("\(nsError.localizedDescription) \n")
        }
    }

    func sendToIroha(_ unsignedQuery:IrohaUnsignedQuery,
                     signedWith keypair: IrohaKeypair,
                     completitionHandler: (Iroha_Protocol_QueryResponse, Error?)->()) throws {

        // Creating helper class for signing unsigned query
        let irohaQueryPreparation = IrohaQueryPreparation()

        let irohaSignedQueryReadyForConvertingToGRPC =
            irohaQueryPreparation.sign(unsignedQuery, with: keypair)

        var irohaGRPCQuery = Iroha_Protocol_Query()

        do {
            try irohaGRPCQuery.merge(serializedData: irohaSignedQueryReadyForConvertingToGRPC)

            LOGGER.userInfo(logClass: self,
                            methodName: #function,
                            description: "How query to Iroha looks like",
                            data: [0 : ("json", "\(try irohaGRPCQuery.payload.jsonString())")])
        } catch {
            let nsError = error as NSError
            print("\(nsError.localizedDescription) \n")
        }

        let serviceForSendingQuery =
            Iroha_Protocol_QueryServiceServiceClient(address: AppConfig.irohaConfig.irohaAddress)

        do {
            let line = "\(#line + 1)"
            let result = try serviceForSendingQuery.find(irohaGRPCQuery)

            LOGGER.networkSuccess(logClass: self,
                                  methodName: #function,
                                  line: line,
                                  description: "Query to Iroha was sucesfully sent",
                                  data: [0:("","\(result)")])

            completitionHandler(result, nil)
        } catch {
            let nsError = error as NSError
            completitionHandler(Iroha_Protocol_QueryResponse(), error)
            print("\(nsError.localizedDescription) \n")
        }
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
