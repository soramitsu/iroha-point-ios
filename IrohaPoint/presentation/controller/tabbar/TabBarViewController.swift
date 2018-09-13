import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let sendVC = SendTableViewController()

        let sendNavCon = UINavigationController(rootViewController: sendVC)
        let sendTabBarItem = UITabBarItem(title: "Send",
                                          image: UIImage(named: "send"),
                                          selectedImage: UIImage(named: "send"))
        sendNavCon.tabBarItem = sendTabBarItem

        let receiveVC = ReceiveTableViewController()

        let receiveNavCon = UINavigationController(rootViewController: receiveVC)
        let receiveTabBarItem = UITabBarItem(title: "Receive",
                                         image: UIImage(named: "receive"),
                                         selectedImage: UIImage(named: "receive"))
        receiveNavCon.tabBarItem = receiveTabBarItem

        let historyVC = HistoryTableViewController()

        let historyNavCon = UINavigationController(rootViewController: historyVC)
        let historyTabBarItem = UITabBarItem(title: "History",
                                         image: UIImage(named: "history"),
                                         selectedImage: UIImage(named: "history"))
        historyNavCon.tabBarItem = historyTabBarItem

        tabBar.barTintColor = .white

        let controllers = [sendNavCon, receiveNavCon, historyNavCon]
        viewControllers = controllers
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
