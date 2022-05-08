import UIKit

final class MainTabBarController: UITabBarController {
    // MARK: - Properties

    // MARK: Private

    private let homeTVC = UINavigationController(rootViewController: HomeViewController())
    private let walletTVC = WalletTableViewController()
    private let settingsTVC = SettingsTableViewController()

    // MARK: - LIfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSetups()
        tabBar.backgroundColor = .theme.background
    }

    // MARK: - Setups

    // MARK: Private

    private func addSetups() {
        addVCToTabBar()
        addImageInTabBar()
        addTitleInTabBar()
    }

    private func addVCToTabBar() {
        setViewControllers([homeTVC, walletTVC, settingsTVC], animated: true)
    }

    private func addImageInTabBar() {
        homeTVC.tabBarItem.image = UIImage(systemName: "house")
        walletTVC.tabBarItem.image = UIImage(systemName: "wallet.pass")
        settingsTVC.tabBarItem.image = UIImage(systemName: "gear")
    }

    private func addTitleInTabBar() {
        homeTVC.title = "Home"
        walletTVC.title = "Wallet"
        settingsTVC.title = "Settings"
        tabBar.tintColor = .theme.accent
    }
}
