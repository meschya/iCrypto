import UIKit

final class MainTabBarController: UITabBarController {
    // MARK: - Properties
    
    // MARK: Public
    
    private var coins: [CoinModel] = [] {
        didSet {
            self.walletTVC.coins = coins
            self.homeTVC.coins = coins
        }
    }

    // MARK: Private

    private let homeTVC = HomeViewController()
    private let walletTVC = WalletTableViewController()
    private let settingsTVC = SettingsTableViewController()

    // MARK: - LIfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSetups()
        tabBar.backgroundColor = .theme.background
        fetchCoins()
    }
    
    // MARK: - Networking
    
    private func fetchCoins() {
        NetworkingManager.instance.getCoins { [weak self] result in
            self?.coins = result
        }
    }

    // MARK: - Setups

    // MARK: Private

    private func addSetups() {
        addVCToTabBar()
        addTitleInTabBar()
    }

    private func addVCToTabBar() {
        let homeTVCNav = UINavigationController(rootViewController: homeTVC)
        setViewControllers([homeTVCNav, walletTVC, settingsTVC], animated: true)
        homeTVCNav.tabBarItem.image = UIImage(systemName: "house")
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
