import UIKit
import CoreData

class WalletTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    // MARK: - Properties
    
    // MARK: Public
    
    var wallets: [Wallet] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var coins: [CoinModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    // MARK: Private

    private var fetchResultController: NSFetchedResultsController<Wallet>!
    private var headerView: WalletStackView = .init()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSetups()
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
        headerView = WalletStackView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 220))
        //tableView.tableHeaderView = headerView
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.identifier, for: indexPath) as? WalletTableViewCell {
            let coin = coins[indexPath.row]
            for wallet in wallets {
                if wallet.coinSymbol == coin.symbol.uppercased() {
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

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
        let context = appDelegate.persistentContainer.viewContext
        let movieDelete = fetchResultController.object(at: indexPath)
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            context.delete(movieDelete)
            appDelegate.saveContext()
            tableView.endUpdates()
        }
    }
}
