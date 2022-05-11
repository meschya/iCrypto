import CoreData
import UIKit

final class WalletTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    // MARK: - Properties

    // MARK: Public

    var coins: [CoinModel] = [] {
        didSet {
            coreDataSetups()
            tableView.reloadData()
        }
    }

    // MARK: Private

    private var wallets: [Wallet] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private var fetchResultController: NSFetchedResultsController<Wallet>!
    private var headerView: WalletStackView = .init()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSetups()
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
                    tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Setups

    // MARK: Private

    private func addSubviews() {}

    private func addSetups() {
        addHeaderView()
        addTableViewSetups()
    }

    private func addTableViewSetups() {
        tableView.separatorStyle = .none
        tableView.register(WalletTableViewCell.self, forCellReuseIdentifier: WalletTableViewCell.identifier)
    }

    private func addHeaderView() {
        headerView = WalletStackView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 60))
        tableView.tableHeaderView = headerView
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.identifier, for: indexPath) as? WalletTableViewCell {
            let wallet = wallets[indexPath.row]
            for coin in coins {
                if coin.symbol.uppercased() == wallet.coinSymbol?.uppercased() {
                    let changeColor = (coin.priceChangePercentage24H ?? 0.0 < 0)
                    cell.walletView.set(coin.name,
                                        coin.symbol,
                                        coin.image,
                                        coin.currentPrice.asCurrencyWith6Decimals(),
                                        coin.priceChangePercentage24H?.asPercentString() ?? "0.0",
                                        changeColor ? .systemRed : .systemGreen,
                                        .init(data: coin.sparklineIn7D?.price ?? [],
                                              showLegend: false,
                                              showAxis: false,
                                              fillColor: changeColor ? .systemRed : .systemGreen),
                                        changeColor ? Change.down.rawValue : Change.up.rawValue)
                    return cell
                }
            }
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coinVC = CoinViewController()
        let wallet = wallets[indexPath.row]
        for coin in coins {
            if coin.symbol.uppercased() == wallet.coinSymbol?.uppercased() {
                coinVC.coin = coin
                coinVC.walletButton.isHidden = true
            }
        }
        present(UINavigationController(rootViewController: coinVC), animated: true)
    }

    // MARK: Fetch request methods

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }

        if let fetchedObjects = controller.fetchedObjects {
            wallets = fetchedObjects as! [Wallet]
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    // MARK: Add Delete button to TableView

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
                let context = appDelegate.persistentContainer.viewContext
                let movieDelete = self.fetchResultController.object(at: indexPath)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                context.delete(movieDelete)
                appDelegate.saveContext()
                tableView.endUpdates()
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
    }
}
