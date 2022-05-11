import UIKit

final class CoinViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: Public
    
    var coin: CoinModel?
    let walletButton: UIButton = .init()
    
    // MARK: Private
    
    private let scrollView: UIScrollView = .init()
    private let mainStackView: UIStackView = .init()
    private let chartView: CryptoLineChartView = .init()
    private let overviewAndWalletButtonStackView: UIStackView = .init()
    private let overviewLabel: UILabel = .init()
    private let capitalizationStackView: CapitalizationStackView = .init()
    private var wallet: Wallet = .init()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addSetups()
        addContraints()
        addInfoCoin()
    }
    
    // MARK: - Constraints
    
    // MARK: Private
    
    private func addContraints() {
        addScrollViewConstraints()
        addMainStackViewConstraints()
        addChartConstraints()
    }
    
    private func addScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func addChartConstraints() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    private func addMainStackViewConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
        mainStackView.heightAnchor.constraint(equalToConstant: 500).isActive = true
    }
    
    // MARK: - Setups
    
    // MARK: Private
    
    private func addSubviews() {
        view.addSubviews(scrollView)
        scrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubviews(chartView,
                                          overviewAndWalletButtonStackView,
                                          capitalizationStackView)
        overviewAndWalletButtonStackView.addArrangedSubviews(overviewLabel,
                                                             walletButton)
    }
    
    private func addSetups() {
        addMainStackViewSetups()
        addViewSetups()
        addNavigationSetups()
        addChartSetups()
        addOverviewLabelSetups()
        addWalletButtonSetups()
    }
    
    private func addMainStackViewSetups() {
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillProportionally
        mainStackView.alignment = .fill
        mainStackView.spacing = 20
    }
    
    private func addChartSetups() {
        chartView.layer.cornerRadius = 20
        chartView.clipsToBounds = true
        chartView.isUserInteractionEnabled = true
    }
    
    private func addOverviewLabelSetups() {
        overviewLabel.text = "Overview"
        overviewLabel.font = .altone(30, .bold)
    }
    
    private func addWalletButtonSetups() {
        walletButton.setTitle("+ Wallet", for: .normal)
        walletButton.setTitleColor(.theme.accent, for: .normal)
        walletButton.addTarget(self, action: #selector(saveCoin), for: .touchUpInside)
    }
    
    private func addViewSetups() {
        view.backgroundColor = .systemBackground
    }
    
    private func addNavigationSetups() {
        title = "Bitcoin"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
    
    // MARK: - Helpers
    
    // MARK: Private
    
    private func addInfoCoin() {
        let changeColor = (coin?.priceChangePercentage24H ?? 0.0 < 0)
        chartView.configure(viewModel:
            .init(
                data: coin?.sparklineIn7D?.price ?? [],
                showLegend: true,
                showAxis: true,
                fillColor: changeColor ? .systemRed : .systemGreen))
        title = coin?.name
        setCurrentPriceLabel()
        setCapitalizationLabel()
        setRankLabel()
        setVolumeLabel()
    }
    
    private func setCurrentPriceLabel() {
        let changeColor = (coin?.priceChangePercentage24H ?? 0.0 < 0)
        capitalizationStackView.setCurrentPriceLabel(coin?.currentPrice.asCurrencyWith6Decimals() ?? "0.0",
                                                     coin?.priceChangePercentage24H?.asPercentString() ?? "0.0",
                                                     changeColor ? .systemRed : .systemGreen)
    }
    
    private func setCapitalizationLabel() {
        let changeMarketColor = (coin?.marketCapChangePercentage24H ?? 0.0 < 0)
        capitalizationStackView.setCapitalizationLabel(coin?.marketCap?.formattedWithAbbreviations() ?? "0.0",
                                                       coin?.marketCapChangePercentage24H?.asPercentString() ?? "0.0",
                                                       changeMarketColor ? .systemRed : .systemGreen)
    }
    
    private func setRankLabel() {
        capitalizationStackView.setRankLabel(coin?.rank ?? 0)
    }
    
    private func setVolumeLabel() {
        capitalizationStackView.setVolumeLabel(coin?.totalVolume?.formattedWithAbbreviations() ?? "0.0")
    }
    
    private func showResultAlert(_ companyName: String) {
        let alert = UIAlertController(title: "Added to WatchList", message: "We've added \(companyName) to your watchlist.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    // MARK: Private
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc private func saveCoin() {
        CoreDataManager.instance.saveWallet(wallet,
                                            coin?.symbol.uppercased() ?? "BTC")
        showResultAlert(coin?.name ?? "Bitcoin")
        walletButton.isHidden = true
    }
}
