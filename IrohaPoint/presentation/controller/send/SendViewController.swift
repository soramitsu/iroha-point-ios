import UIKit

class SendTableViewController: UITableViewController {

    var sectionHeaderView: AccountSectionHeaderView!

//    @IBOutlet weak var tableView: SendTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        }
        title = "Send"

//        tableView.configure(withTabBarHeight: tabBarController?.tabBar.frame.size.height ?? 0.0,
//                            withNavBarHeight: navigationController?.navigationBar.frame.height ?? 0.0)

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(SendTableViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = .red
        
        self.refreshControl = refreshControl

        registerCells(named: [.accountTableViewCell,
                              .sendTableViewCell,
                              .sendTokenTableViewCell])
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("handleRefresh(_ refreshControl: UIRefreshControl)")
        refreshControl.endRefreshing()
    }

    override func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //sendDelegate?.didSelectTypeInfo()
        }
        if indexPath.row == 1 {
            //sendDelegate?.didSelectScanQRCode()
        }
    }
    
    override func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0,
                           y: 0,
                           width: UIScreen.main.bounds.size.width,
                           height: 50)
        sectionHeaderView = AccountSectionHeaderView(frame: frame)
        // sectionHeaderView.delegate = self
        sectionHeaderView.layer.shadowOpacity = 0.1
        sectionHeaderView.layer.shadowColor = UIColor.black.cgColor
        sectionHeaderView.layer.shadowOffset = CGSize(width: 0, height: 0)
        sectionHeaderView.layer.shadowRadius = 3
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

