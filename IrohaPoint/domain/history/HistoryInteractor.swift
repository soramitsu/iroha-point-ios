import UIKit
import SwiftDate

class HistoryInteractor {

    var controller: HistoryInteractorOutput!

    private var irohaService: IrohaServiceInput!
    private var userDefaults: KeyValueStorage!
    private var keychain: KeyValueStorage!

    init(irohaService: IrohaServiceInput,
         userDefaults: KeyValueStorage,
         keychain: KeyValueStorage) {
        self.irohaService = irohaService
        self.userDefaults = userDefaults
        self.keychain = keychain
    }
}

extension HistoryInteractor: HistoryInteractorInput {
    func getTransactionHistory() {
        var user = User(username: "")
        var userKeypair = Keypair(publicKey: "", privateKey: "")
        do {
            guard let userKeypairFromKeychain: Keypair = try keychain.readValue(for: StorageData.keypair),
                let userFromKeychain: User = try keychain.readValue(for: StorageData.appUser) else {
                return
            }
            userKeypair = userKeypairFromKeychain
            user = userFromKeychain
        } catch {

        }
        DispatchQueue.global().async {
            self.irohaService.getTransactionHistory(for: user, signedWith: userKeypair)
        }
    }
}


extension HistoryInteractor: IrohaServiceOutput {
    func didGet(_ transactionHistory: [TransactionHistory]) {
        divideIntoSections(transactionHistory)
        DispatchQueue.main.async {
            self.controller.didGet(transactionHistory)
        }
    }

    private func divideIntoSections(_ transactions: [TransactionHistory]) ->
        ([String], [[TransactionHistory]]) {

            var sectionsAndTransactions = [Date:[TransactionHistory]]()

            for transaction in transactions {
                let date = convertDate(from: transaction)
                sectionsAndTransactions.updateValue([], forKey: date)
            }

            for transaction in transactions {
                let date = convertDate(from: transaction)
                var arrayForSection = sectionsAndTransactions[date]!
                arrayForSection.append(transaction)
                sectionsAndTransactions.updateValue(arrayForSection, forKey: date)
            }

            for (date, transaction) in sectionsAndTransactions {
                let sorted = transaction.sorted {

                    if $0.dateInRegion.hour > $1.dateInRegion.hour {
                        return true
                    } else if $0.dateInRegion.hour < $1.dateInRegion.hour {
                        return false
                    }

                    if $0.dateInRegion.minute > $1.dateInRegion.minute {
                        return true
                    } else if $0.dateInRegion.minute < $1.dateInRegion.minute {
                        return false
                    }

                    if $0.dateInRegion.second > $1.dateInRegion.second {
                        return true
                    } else if $0.dateInRegion.second < $1.dateInRegion.second {
                        return false
                    }

                    return false
                }

                sectionsAndTransactions.updateValue(sorted, forKey: date)
            }

            let sorted = sectionsAndTransactions.sorted {

                if $0.key.year > $1.key.year {
                    return true
                } else if $0.key.year < $1.key.year {
                    return false
                }

                if $0.key.month > $1.key.month {
                    return true
                } else if $0.key.month < $1.key.month {
                    return false
                }

                if $0.key.day > $1.key.day {
                    return true
                } else if $0.key.day < $1.key.day {
                    return false
                }

                return false
            }

            var arrayOfSortedDates = [String]()
            var arrayOfSortedTransactions = [[TransactionHistory]]()
            let currentRegion = Region(tz: TimeZoneName.init(rawValue: TimeZone.current.identifier)!,
                                       cal: CalendarName.gregorian,
                                       loc: LocaleName.init(rawValue: languageService.getCurrentLanguage().systemName)!)

            for transaction in sorted {
                if transaction.key.isToday {
                    arrayOfSortedDates.append("Today".localized)
                } else if transaction.key.isYesterday {
                    arrayOfSortedDates.append("Yesterday".localized)
                } else {
                    arrayOfSortedDates.append(transaction.key.string(format: DateFormat.custom("dd MMMM yyyy"),
                                                                     in: currentRegion))
                }
                arrayOfSortedTransactions.append(transaction.value)
            }

            return (arrayOfSortedDates, arrayOfSortedTransactions)
    }

    private func convertDate(from transaction: TransactionHistory) -> Date {
        let transactionDate = transaction.dateInRegion.absoluteDate

        var cmp = DateComponents()
        cmp.timeZone = TimeZone.current
        cmp.calendar = CalendarName.gregorian.calendar
        cmp.calendar?.locale = Locale(identifier: languageService.getCurrentLanguage().systemName)
        cmp.year = transactionDate.year
        cmp.month = transactionDate.month
        cmp.day = transactionDate.day

        return DateInRegion(components: cmp)!.absoluteDate
    }
}

