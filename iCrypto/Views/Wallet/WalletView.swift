import Kingfisher
import UIKit

final class WalletView: UIView {
    // MARK: - Properties
    
    // MARK: Private
    
    private let mainWalletView: UIView = .init()
    private let mainStackView: UIStackView = .init()
    private let nameAndIconStackView: UIStackView = .init()
    private let nameCoinLabel: UILabel = .init()
    private let coinImageView: UIImageView = .init()
    private let currentPriceLabel: UILabel = .init()
    private let changeStackView: UIStackView = .init()
    private let changeImageView: UIImageView = .init()
    private let changeLabel: UILabel = .init()
    private let chartAndExchangeStackView: UIStackView = .init()
    private let chartView: CryptoLineChartView = .init()
    private let binanceImageView: UIImageView = .init()
    private let krakenImageView: UIImageView = .init()
    private let bitfinexImageView: UIImageView = .init()
    private let spacer: UIView = .init()
    
    // MARK: - Enum
    
    // MARK: Private
    
    private enum Exchange: String {
        case binance
        case kraken
        case bitfinex
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addContraints()
        addSetups()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [weak self] in
            self?.addCoinImageViewSetups()
            self?.addBinanceImageViewSetups()
            self?.addKrakenImageViewSetups()
            self?.addBitfinexImageViewSetups()
        }
    }
    
    // MARK: - API
    
    func set(_ coinName: String, _ coinSymbol: String, _ image: String, _ price: String, _ change: String, _ color: UIColor, _ data: CryptoLineChartView.ViewModel, _ changeImage: String) {
        nameCoinLabel.attributedText = modificatorForNameCoinLabel(coinName, coinSymbol)
        coinImageView.kf.setImage(with: URL(string: image))
        currentPriceLabel.text = price
        changeLabel.text = change
        changeLabel.textColor = color
        backgroundColor = color
        changeImageView.image = UIImage(systemName: changeImage)
        changeImageView.tintColor = color
        chartView.configure(viewModel: data)
    }
    
    // MARK: - Constraints
    
    // MARK: Private
    
    private func addContraints() {
        addMainWalletViewConstraints()
        addMainStackViewConstraints()
        addCoinImageViewConstraints()
        addСhangeImageViewConstraints()
        addExchangeImageViewConstraints()
    }
    
    private func addMainWalletViewConstraints() {
        mainWalletView.translatesAutoresizingMaskIntoConstraints = false
        mainWalletView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        mainWalletView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -10).isActive = true
        mainWalletView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10).isActive = true
        mainWalletView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func addMainStackViewConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(equalTo: mainWalletView.topAnchor, constant: 10).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: mainWalletView.leadingAnchor, constant: 10).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: mainWalletView.trailingAnchor, constant: -10).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: mainWalletView.bottomAnchor, constant: -10).isActive = true
    }
    
    private func addCoinImageViewConstraints() {
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        coinImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        coinImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    private func addExchangeImageViewConstraints() {
        // Binance
        binanceImageView.translatesAutoresizingMaskIntoConstraints = false
        binanceImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        binanceImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Kraken
        krakenImageView.translatesAutoresizingMaskIntoConstraints = false
        krakenImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        krakenImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Bitfinex
        bitfinexImageView.translatesAutoresizingMaskIntoConstraints = false
        bitfinexImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bitfinexImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        spacer.widthAnchor.constraint(equalTo: chartAndExchangeStackView.widthAnchor, multiplier: 0.3).isActive = true
    }
    
    private func addСhangeImageViewConstraints() {
        changeImageView.translatesAutoresizingMaskIntoConstraints = false
        changeImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        changeImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    // MARK: - Setups
    
    // MARK: Private
    
    private func addSubviews() {
        addSubview(mainWalletView)
        mainWalletView.addSubview(mainStackView)
        mainStackView.addArrangedSubviews(nameAndIconStackView,
                                          currentPriceLabel,
                                          changeStackView,
                                          chartAndExchangeStackView)
        nameAndIconStackView.addArrangedSubviews(nameCoinLabel,
                                                 coinImageView)
        changeStackView.addArrangedSubviews(changeImageView,
                                            changeLabel)
        chartAndExchangeStackView.addArrangedSubviews(chartView, spacer, binanceImageView, krakenImageView, bitfinexImageView)
    }
    
    private func addSetups() {
        addMainViewSetups()
        addMainWalletViewSetups()
        addMainStackViewSetups()
        addNameCoinLabelSetups()
        addCurrentPriceLabelSetups()
        addChangeImageViewSetups()
        addChangeLabelSetups()
        addChangeStackViewSetups()
        addNameAndIconStackViewSetups()
        addChartAndExchangeStackViewSetups()
        addChartViewSetups()
    }
    
    private func addMainViewSetups() {
        backgroundColor = .systemGreen
        layer.cornerRadius = 15
    }
    
    private func addMainWalletViewSetups() {
        mainWalletView.backgroundColor = .theme.cellColor
        mainWalletView.layer.cornerRadius = 15
    }
    
    private func addMainStackViewSetups() {
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillProportionally
        mainStackView.alignment = .fill
        mainStackView.spacing = 10
    }
    
    private func addNameAndIconStackViewSetups() {
        nameAndIconStackView.alignment = .center
    }
    
    private func addChangeStackViewSetups() {
        changeStackView.spacing = 10
    }
    
    private func addChartAndExchangeStackViewSetups() {
        chartAndExchangeStackView.spacing = -10
    }
    
    private func addNameCoinLabelSetups() {
        nameCoinLabel.numberOfLines = 2
    }
    
    private func addCoinImageViewSetups() {
        coinImageView.layer.cornerRadius = coinImageView.frame.size.width / 2
        coinImageView.clipsToBounds = true
        coinImageView.contentMode = .scaleAspectFill
    }
    
    private func addBinanceImageViewSetups() {
        binanceImageView.image = UIImage(named: Exchange.binance.rawValue)
        binanceImageView.layer.cornerRadius = binanceImageView.frame.size.width / 2
        binanceImageView.clipsToBounds = true
        binanceImageView.contentMode = .scaleAspectFill
    }
    
    private func addKrakenImageViewSetups() {
        krakenImageView.image = UIImage(named: Exchange.kraken.rawValue)
        krakenImageView.layer.cornerRadius = krakenImageView.frame.size.width / 2
        krakenImageView.clipsToBounds = true
        krakenImageView.contentMode = .scaleAspectFill
    }
    
    private func addBitfinexImageViewSetups() {
        bitfinexImageView.image = UIImage(named: Exchange.bitfinex.rawValue)
        bitfinexImageView.layer.cornerRadius = bitfinexImageView.frame.size.width / 2
        bitfinexImageView.clipsToBounds = true
        bitfinexImageView.contentMode = .scaleAspectFill
    }
    
    private func addCurrentPriceLabelSetups() {
        currentPriceLabel.text = "$30.000"
        currentPriceLabel.font = .altone(30, .bold)
    }
    
    private func addChangeImageViewSetups() {
        changeImageView.image = UIImage(systemName: "arrowtriangle.up.fill")
        changeImageView.tintColor = .systemGreen
    }
    
    private func addChangeLabelSetups() {
        changeLabel.text = "-0.3%"
        changeLabel.font = .altone(15, .light)
        changeLabel.textColor = .systemGreen
    }
    
    private func addChartViewSetups() {
        chartView.clipsToBounds = true
        chartView.isUserInteractionEnabled = false
    }
    
    // MARK: - Helpers
    
    // MARK: Private
    
    private func modificatorForNameCoinLabel(_ coinName: String, _ coinSymbol: String) -> NSMutableAttributedString {
        let firstAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.altone(20, .bold)
        ]
        
        let secondAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont.altone(12, .medium)
        ]
        
        let firstString = NSMutableAttributedString(string: "\(coinName)\n", attributes: firstAttributes)
        
        let secondString = NSAttributedString(string: "\(coinSymbol.uppercased())", attributes: secondAttributes)
        firstString.append(secondString)
        return firstString
    }
}
