import UIKit

class WalletTableViewController: UITableViewController {
    // MARK: - Properties

    // MARK: Private

    private var headerView: WalletStackView = .init()
    var coins: [CoinModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSetups()
    }
    
    // MARK: - Networking
    
    private func fetchCoins() {
        NetworkingManager.instance.getCoins { [weak self] result in
            self?.coins = result
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
        headerView = WalletStackView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 220))
        //tableView.tableHeaderView = headerView
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.identifier, for: indexPath) as? WalletTableViewCell {
            let coin = coins[indexPath.row]
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
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
