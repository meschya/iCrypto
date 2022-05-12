import CoreData
import UIKit

final class MainTabBarController: UITabBarController, NSFetchedResultsControllerDelegate {
    // MARK: - Properties

    // MARK: Private

    private var coins: [CoinModel] = [] {
        didSet {
            walletTVC.coins = coins
            homeTVC.coins = coins
        }
    }

    private var wallets: [Wallet] = [] {
        didSet {
            homeTVC.wallets = wallets
        }
    }

    private var fetchResultController: NSFetchedResultsController<Wallet>!
    private var profileFetchResultController: NSFetchedResultsController<Profile>!
    private let homeTVC = HomeViewController()
    private let walletTVC = WalletTableViewController()
    private let settingsVC = SettingsViewController()

    // MARK: - LIfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSetups()
        tabBar.backgroundColor = .theme.background
        fetchCoins()
        coreDataSetups()
    }

    // MARK: - CoreData

    private func coreDataSetups() {
        let fetchRequest: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "coinSymbol", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    wallets = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
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
        setViewControllers([homeTVCNav, walletTVC, settingsVC], animated: true)
        homeTVCNav.tabBarItem.image = UIImage(systemName: "house")
        walletTVC.tabBarItem.image = UIImage(systemName: "wallet.pass")
        settingsVC.tabBarItem.image = UIImage(systemName: "gear")
    }

    private func addTitleInTabBar() {
        homeTVC.title = "Home"
        walletTVC.title = "Wallet"
        settingsVC.title = "Settings"
        tabBar.tintColor = .theme.accent
    }
}
