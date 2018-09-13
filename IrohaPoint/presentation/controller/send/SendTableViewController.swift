import UIKit

class SendTableViewController: BaseTableViewController {

    var interactor: SendInteractorInput!

    var sectionHeaderView: AccountSectionHeaderView!

    var user: User!
    var currentTokensAmount: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Send"

        SendAssembly.configure(self)

        tableView.separatorStyle = .none

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(SendTableViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = .red
        
        self.refreshControl = refreshControl

        tableView.registerCells(named: [.accountTableViewCell,
                                        .sendTableViewCell,
                                        .sendTokenTableViewCell])

        user = interactor.getUser()
        sectionHeaderView = AccountSectionHeaderView(frame: AppDesign.size.ACCOUNT_INFO_FRAME)
        sectionHeaderView.set(username: user.username)

        interactor.getBalance(for: user)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentTokensAmount == nil {
            sectionHeaderView.isLoading = true
        }
        interactor.getBalance(for: user)
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        sectionHeaderView.isLoading = true
        interactor.getBalance(for: user)
        refreshControl.endRefreshing()
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let sendByUsernameVC = SendByUsernameViewController()
            sendByUsernameVC.user = user
            if currentTokensAmount != nil {
                sendByUsernameVC.currentTokensAmount = currentTokensAmount
                sendByUsernameVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(sendByUsernameVC, animated: true)
            } else {
                let alertController = UIAlertController(title: "You are offline",
                                                        message: "Please, enable internet acccess",
                                                        preferredStyle: .alert)

                let okAction = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
                    self.dismiss(animated: true)
                })

                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }
        }
        if indexPath.row == 1 {
            let qrScanVC = QRScanViewController()
            if currentTokensAmount != nil {
                qrScanVC.currentTokensAmount = currentTokensAmount
                qrScanVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(qrScanVC, animated: true)
            } else {
                let alertController = UIAlertController(title: "You are offline",
                                                        message: "Please, enable internet acccess",
                                                        preferredStyle: .alert)

                let okAction = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
                    self.dismiss(animated: true)
                })

                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView
    }

    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(named: .sendTokenTableViewCell) as! SendTokenTableViewCell
        if indexPath.row == 0 {
            cell.set(backgroundGradient: AppDesign.gradient.RED)
            cell.set(image: UIImage(named: "write"))
            cell.set(title: "Type username")
            cell.set(info: "You can send tokens to other users by simply typing their usernames and amount to send")
        }
        if indexPath.row == 1 {
            cell.set(backgroundGradient: AppDesign.gradient.ORANGE)
            cell.set(image: UIImage(named: "qr"))
            cell.set(title: "Scan QR-code")
            cell.set(info: "You can send tokens to other users by scanning theirs QR-codes")
        }
        return cell
    }
}

extension SendTableViewController: SendInteractorOutput {
    func didGet(_ tokensAmount: Int) {
        currentTokensAmount = tokensAmount
        sectionHeaderView.isLoading = false
        sectionHeaderView.amount = "\(tokensAmount) irh"
    }

    func didNotGetTokensAmount() {
        currentTokensAmount = nil
        sectionHeaderView.isLoading = false
        sectionHeaderView.amount = "Pull to update"
    }
}
