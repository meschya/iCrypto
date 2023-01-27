import CoreData
import UIKit

final class MainTabBarController: UITabBarController, NSFetchedResultsControllerDelegate {
    // MARK: - Properties
    
    // MARK: Public
    
    var presenter: MainViewPresenterProtocol?

    // MARK: Private

//    private var wallets: [Wallet] = [] {
//        didSet {
//            homeTVC.wallets = wallets
//        }
//    }

    private var fetchResultController: NSFetchedResultsController<Wallet>!
    private var profileFetchResultController: NSFetchedResultsController<Profile>!
    private let homeTVC = ModuleBuilder.createHomeModule()
    private let walletTVC = WalletTableViewController()
    private let settingsVC = SettingsViewController()

    // MARK: - LIfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSetups()
        tabBar.backgroundColor = .theme.background
        coreDataSetups()
        presenter?.fetchCoins()
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
                   // wallets = fetchedObjects
                }
            } catch {
                print(error)
            }
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

extension MainTabBarController: MainViewProtocol {
    func success() {
        walletTVC.coins = presenter?.coins ?? []
      //  homeTVC.coins = presenter?.coins ?? []
    }
}
