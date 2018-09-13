import UIKit

class ReceiveTableViewController: BaseTableViewController {

    var user: User!
    var currentTokensAmount: Int!

    var interactor: ReceiveInteractorInput!
    
    var sectionHeaderView: AccountSectionHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Receive"

        ReceiveAssembly.configure(self)

        tableView.separatorStyle = .none

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(SendTableViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = .red

        self.refreshControl = refreshControl

        tableView.registerCells(named: [.sendTokenTableViewCell])

        user = interactor.getUser()
        sectionHeaderView = AccountSectionHeaderView(frame: AppDesign.size.ACCOUNT_INFO_FRAME)
        sectionHeaderView.set(username: user.username)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentTokensAmount == nil {
            sectionHeaderView.isLoading = true
        }
        interactor.getBalance()
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        sectionHeaderView.isLoading = true
        interactor.getBalance()
        refreshControl.endRefreshing()
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let generateQR = GenerateQrViewController()
            generateQR.hidesBottomBarWhenPushed = true
            generateQR.user = user
            navigationController?.pushViewController(generateQR, animated: true)
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
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(named: .sendTokenTableViewCell) as! SendTokenTableViewCell
        if indexPath.row == 0 {
            cell.set(backgroundGradient: AppDesign.gradient.GREEN)
            cell.set(image: UIImage(named: "qr"))
            cell.set(title: "Generate your QR-code")
            cell.set(info: "You can receive tokens from other users by providing them your QR-code")
        }
        return cell
    }
}

extension ReceiveTableViewController: ReceiveInteractorOutput {
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

