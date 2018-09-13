import UIKit

class HistoryTableViewController: UITableViewController {

    var interactor: HistoryInteractorInput!

    var sections = [String]()
    var transactions = [[TransactionHistory]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "History"

        TransactionHistoryAssembly.configure(self)

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        }
        tableView.separatorStyle = .none

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(SendTableViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = .red

        self.refreshControl = refreshControl

        tableView.registerCells(named: [.historyTableViewCell])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor.getTransactionHistory()
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        interactor.getTransactionHistory()
        refreshControl.endRefreshing()
    }

    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(named: .historyTableViewCell) as! HistoryTableViewCell
        cell.set(transactions[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {

        if transactions.count == 0 {
            tableView.separatorStyle = .none
            return 1
        }

        tableView.separatorStyle = .singleLine
        return transactions[section].count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if transactions.count == 0 {
            return 1
        }
        return sections.count
    }
}

extension HistoryTableViewController: HistoryInteractorOutput {
    func didGet(_ transactionHistory: [TransactionHistory]) {
        self.transactions = transactionHistory
        tableView.reloadData()
    }
}
