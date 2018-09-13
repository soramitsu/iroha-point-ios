import UIKit

protocol ReceiveTableViewDelegate: class {
    func didSelectTypeInfo()
    func didSelectScanQRCode()
}

final class ReceiveTableView: UITableView {

    private let accountCellHeight: CGFloat = 100
    private var tabBarHeight: CGFloat = 0
    private var navBarHeight: CGFloat = 0
    private var sendCellHeight: CGFloat = 0
    private var sendCellMinimalHeight: CGFloat = 400.0

    weak var sendDelegate: ReceiveTableViewDelegate?

    var sectionHeaderView: AccountSectionHeaderView!

    func configure(withTabBarHeight tabBarHeight: CGFloat,
                   withNavBarHeight navBarHeight: CGFloat) {
        separatorStyle = .none
        delegate = self
        dataSource = self
        registerCells(named: [.accountTableViewCell,
                              .sendTableViewCell,
                              .sendTokenTableViewCell])

        showsVerticalScrollIndicator = false

        self.tabBarHeight = tabBarHeight
        self.navBarHeight = navBarHeight

        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height

        sendCellHeight = (screenHeight - accountCellHeight - UIApplication.shared.statusBarFrame.height - tabBarHeight - navBarHeight) - 60

        contentInset = UIEdgeInsetsMake(0, 0, sendCellHeight, 0)
    }
}

extension ReceiveTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            sendDelegate?.didSelectTypeInfo()
        }
        if indexPath.row == 1 {
            sendDelegate?.didSelectScanQRCode()
        }
    }
}

extension ReceiveTableView: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView,
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

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
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

