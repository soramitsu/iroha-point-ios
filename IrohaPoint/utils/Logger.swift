import UIKit

var LOGGER = DNLogger.shared

final class DNLogger {

    private var currentLogClassString: String?
    private var currentMethodName: String?

    private var dateInFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSSS"
        return dateFormatter.string(from: Date())
    }

    static let shared = DNLogger()

    func systemError(logClass: Any,
                     methodName: String,
                     description: String,
                     message: String) {

        let logClassString = String(describing: type(of: logClass))

        print("==================================================\n\n\t" +
            "❌ [ERROR]: \(description)\n\n\t" +
            "[time]: \(dateInFormat)\n\t" +
            "[methodName]: \(logClassString).\(methodName)\n\t" +
            "[description]: \(description)\n\n\t" +
            "MESSSAGE:\n\n\t" +
            "\(message)\n==================================================" )
    }

    func systemInfo(logClass: Any,
                    methodName: String,
                    data: [Int: (String, String)]) {

        let logClassString = String(describing: type(of: logClass))

        var logString = ""

        for i in 0...data.count-1 {
            logString += "⚙️ [\(dateInFormat)] \(data[i]!.0)\n\n" +
            "\(data[i]!.1)\n"
        }

        print("⚙️ \(logClassString).\(methodName)\n" + logString)
    }

    func userInfo(logClass: Any,
                  methodName: String,
                  description: String,
                  data: [Int: (String, String)]? = nil) {

        let logClassString = String(describing: type(of: logClass))

        var logString = ""

        if let data = data {
            for i in 0...data.count-1 {
                if data[i]!.0.isEmpty {
                    logString += "\t\(data[i]!.1)\n"
                } else {
                    logString += "\t[\(data[i]!.0)]: \(data[i]!.1)\n"
                }
            }
        }

        print("==================================================\n\n\t" +
            "ℹ️ [INFO]: \(description)\n\n\t" +
            "[time]: \(dateInFormat)\n\t" +
            "[methodName]: \(logClassString).\(methodName)\n\t" +
            "[description]: \(description)\n\n\t" +
            "INFORMATION:\n\n" +
            "\(logString)\n==================================================" )
    }

    func networkInfo(logClass: Any,
                     methodName: String,
                     description: String,
                     data: [Int: (String, String)]) {

        let logClassString = String(describing: type(of: logClass))

        var logString = ""

        for i in 0...data.count-1 {
            if data[i]!.0.isEmpty {
                logString += "\t\(data[i]!.1)\n"
            } else {
                logString += "\t[\(data[i]!.0)]: \(data[i]!.1)\n"
            }
        }

        print("==================================================\n\n\tℹ️ NETWORK REQUEST:\n\n\t[time]: \(dateInFormat)\n\t[methodName]: \(logClassString).\(methodName)\n\t[description]: \(description)\n\n\tINFORMATION:\n\n\(logString)\n==================================================" )
    }

    func networkSuccess(logClass: Any,
                        methodName: String,
                        line: String,
                        description: String,
                        data: [Int: (String, String)]) {

        let logClassString = String(describing: type(of: logClass))

        var logString = ""

        for i in 0...data.count-1 {
            if data[i]!.0.isEmpty {
                logString += "\t\(data[i]!.1)\n"
            } else {
                logString += "\t[\(data[i]!.0)]: \(data[i]!.1)\n"
            }
        }

        print("==================================================\n\n\t✅ [NETWORK REQUEST]: \(description)\n\n\t[time]: \(dateInFormat)\n\t[methodName]: \(logClassString).\(methodName) in line \(line)\n\t[description]: \(description)\n\n\tINFORMATION:\n\n\(logString)\n==================================================" )
    }

    func networkError(logClass: Any,
                      methodName: String,
                      data: [Int: (String, String)]) {
    }

    func printLogTree(logClass: Any,
                      methodName: String,
                      message: String) {

        let semaphore = DispatchSemaphore(value: 0)

        DispatchQueue.global().async {
            let logClassString = String(describing: type(of: logClass))
            if self.currentLogClassString != nil &&
                logClassString == self.currentLogClassString! {
                if self.currentMethodName != nil &&
                    self.currentMethodName == methodName {
                    print("🔵 [I]·········\"\(message)\" in \(self.dateInFormat)")
                } else {
                    print("⚪️ [M]······\(methodName)" +
                        "\n🔵 [I]·········\"\(message)\" in \(self.dateInFormat)")
                }
            } else {
                print("⚪️ [C]···\(logClassString)" +
                    "\n⚪️ [M]······\(methodName)" +
                    "\n🔵 [I]·········\"\(message)\" in \(self.dateInFormat)")
            }

            self.currentLogClassString = logClassString
            self.currentMethodName = methodName
            semaphore.signal()
        }

        semaphore.wait()
    }
}
