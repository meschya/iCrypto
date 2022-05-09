import FloatingPanel
import UIKit

final class HomeViewController: UIViewController {
    // MARK: - Properties

    // MARK: Private

    private let refreshControl: UIRefreshControl = .init()
    private let panel: FloatingPanelController = .init()
    private let cryptoTableView: UITableView = .init()
    private var headerView = WelcomeStackView()
    private var coins: [CoinModel] = [] {
        didSet {
            self.cryptoTableView.reloadData()
            self.headerView.coins = coins
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addSetups()
        fetchCoins()
        refreshTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Networking
    
    private func fetchCoins() {
        NetworkingManager.instance.getCoins { [weak self] result in
            self?.coins = result
        }
    }

    // MARK: - Setups

    // MARK: Private

    private func addSubviews() {
        view.addSubview(cryptoTableView)
    }

    private func addSetups() {
        addCryptoTableViewSetups()
        setUpFloatingPanel()
        addHeaderView()
    }
    
    private func addCryptoTableViewSetups() {
        view.backgroundColor = .systemBackground
        cryptoTableView.frame = view.bounds
        cryptoTableView.backgroundColor = .systemBackground
        cryptoTableView.delegate = self
        cryptoTableView.dataSource = self
        cryptoTableView.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.identifier)
    }

    private func setUpFloatingPanel() {
        let vc = NewsTableViewController()
        panel.surfaceView.backgroundColor = .theme.cellColor
        panel.set(contentViewController: vc)
        panel.surfaceView.appearance.cornerRadius = 20
        panel.addPanel(toParent: self)
        //  panel.track(scrollView: vc.tableView)
    }
    
    // MARK: - Helpers
    
    // MARK: Private
    
    private func addHeaderView() {
        headerView = WelcomeStackView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 420))
       // headerView.tableHeaderStackView.delegate = self
     //   headerView.setCount(notes.count)
        headerView.delegate = self
        cryptoTableView.tableHeaderView = headerView
    }
    
    private func refreshTable() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        cryptoTableView.refreshControl = refreshControl
    }
    
    // MARK: - Actions
    
    // MARK: Private
    
    @objc private func refresh() {
        NetworkingManager.instance.getCoins { [weak self] result in
            self?.coins = result
            self?.refreshControl.endRefreshing()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.identifier, for: indexPath) as? CoinTableViewCell {
            let coin = coins[indexPath.row]
            let changeColor = (coin.priceChangePercentage24H ?? 0.0 < 0)
            cell.set(coin.image,
                     coin.name,
                     coin.symbol.uppercased(),
                     coin.currentPrice.asCurrencyWith6Decimals(),
                     coin.priceChangePercentage24H?.asPercentString() ?? "0.0",
                     changeColor ? .systemRed : .systemGreen,
                     .init(data: coin.sparklineIn7D?.price ?? [],
                           showLegend: false,
                           showAxis: false,
                           fillColor: changeColor ? .systemRed : .systemGreen))
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(coins[indexPath.row].symbol)
    }
}

extension HomeViewController: TransferActionsBetweenVCDelegate {
    func viewScreen(_ addInvestments: AddInvestmentsViewController) {
        if !coins.isEmpty {
            navigationController?.pushViewController(addInvestments, animated: true)
            addInvestments.coins = coins
        }
    }
}
