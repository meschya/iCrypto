import UIKit
import Kingfisher

final class InvestmentsCollectionViewCell: UICollectionViewCell {
    // MARK: - Identifier
    
    static let identifier = "TagCollectionViewCell"
    
    // MARK: - Properties
    
    // MARK: Private
    
    private let investmentsView: UIView = .init()
    private let investmentsStackView: UIStackView = .init()
    private let coinStackView: UIStackView = .init()
    private let coinImageView: UIImageView = .init()
    private let coinLabel: UILabel = .init()
    private let settingsImageView: UIImageView = .init()
    private let progressView: UIProgressView = .init()
    private let infoStackView: UIStackView = .init()
    private let investmentLabel: UILabel = .init()
    private let profitLabel: UILabel = .init()
    
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
        DispatchQueue.main.async {
            self.addCoinImageViewSetups()
            self.profitLabel.setLineSpacing(lineSpacing: 4.0)
            self.investmentLabel.setLineSpacing(lineSpacing: 4.0)
        }
    }
    
    // MARK: - API
    
    func set(_ symbolCoin: String, _ nameCoin: String, _ invest: Double, _ targetPrice: Double, _ change: String, _ priceCoin: Double, _ image: String, _ color: UIColor, _ buyingPrice: Double) {
        let result = (invest / buyingPrice) * priceCoin
        coinLabel.attributedText = modificatorForCoinLabel(symbolCoin, nameCoin)
        investmentLabel.attributedText = modificatorForInvestmentLabel(Int(invest))
        profitLabel.attributedText = modificatorForProfitLabel(Int(targetPrice), result.asNumberString(), change, color)
        coinImageView.kf.setImage(with: URL(string: image))
        progressView.progress = Float(result)/Float(targetPrice)
    }
    
    // MARK: - Constraints
    
    // MARK: Private
    
    private func addContraints() {
        addInvestmentsViewConstraints()
        addInvestmentsStackViewConstraints()
        addCoinImageViewConstraints()
        addSettingsImageViewConstraints()
        addCoinStackViewConstraints()
    }
    
    private func addInvestmentsViewConstraints() {
        investmentsView.translatesAutoresizingMaskIntoConstraints = false
        investmentsView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        investmentsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        investmentsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        investmentsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    private func addInvestmentsStackViewConstraints() {
        investmentsStackView.translatesAutoresizingMaskIntoConstraints = false
        investmentsStackView.topAnchor.constraint(equalTo: investmentsView.topAnchor, constant: 10).isActive = true
        investmentsStackView.leadingAnchor.constraint(equalTo: investmentsView.leadingAnchor, constant: 10).isActive = true
        investmentsStackView.trailingAnchor.constraint(equalTo: investmentsView.trailingAnchor, constant: -10).isActive = true
        investmentsStackView.bottomAnchor.constraint(equalTo: investmentsView.bottomAnchor, constant: -10).isActive = true
    }
    
    private func addCoinStackViewConstraints() {
        coinStackView.translatesAutoresizingMaskIntoConstraints = false
        coinStackView.heightAnchor.constraint(equalTo: investmentsStackView.heightAnchor, multiplier: 0.3).isActive = true
    }
    
    private func addCoinImageViewConstraints() {
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        coinImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        coinImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func addSettingsImageViewConstraints() {
        settingsImageView.translatesAutoresizingMaskIntoConstraints = false
        settingsImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        settingsImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    // MARK: - API
    
    func set(_ text: String) {}
    
    // MARK: - Setups
    
    // MARK: Private
    
    private func addSubviews() {
        contentView.addSubview(investmentsView)
        investmentsView.addSubview(investmentsStackView)
        investmentsStackView.addArrangedSubviews(coinStackView,
                                                 progressView,
                                                 infoStackView)
        coinStackView.addArrangedSubviews(coinImageView,
                                          coinLabel,
                                          settingsImageView)
        infoStackView.addArrangedSubviews(investmentLabel,
                                          profitLabel)
    }
    
    private func addSetups() {
        addContentViewSetups()
        addInvestmentsViewSetups()
        addInvestmentsStackViewSetups()
        addCoinStackViewSetups()
        addInfoStackViewSetups()
        addCoinImageViewSetups()
        addCoinLabelSetups()
        addSettingsImageView()
        addInvestmentLabelSetups()
        addProfitLabelSetups()
    }
    
    private func addContentViewSetups() {
        contentView.backgroundColor = .systemBackground
    }
    
    private func addInvestmentsViewSetups() {
        investmentsView.backgroundColor = .theme.cellColor
        investmentsView.layer.cornerRadius = 15
    }
    
    private func addInvestmentsStackViewSetups() {
        investmentsStackView.axis = .vertical
        investmentsStackView.distribution = .fillProportionally
        investmentsStackView.alignment = .fill
        investmentsStackView.spacing = 15
    }
    
    private func addCoinStackViewSetups() {
        coinStackView.axis = .horizontal
        coinStackView.distribution = .fillProportionally
        coinStackView.alignment = .center
        coinStackView.spacing = 10
    }
    
    private func addInfoStackViewSetups() {
        infoStackView.axis = .horizontal
        infoStackView.distribution = .fillProportionally
        infoStackView.alignment = .top
    }
    
    private func addCoinImageViewSetups() {
        coinImageView.layer.cornerRadius = coinImageView.frame.size.width / 2
        coinImageView.clipsToBounds = true
        coinImageView.contentMode = .scaleAspectFill
    }
    
    private func addCoinLabelSetups() {
        coinLabel.numberOfLines = 2
    }
    
    private func addSettingsImageView() {
        settingsImageView.image = UIImage(systemName: "ellipsis")
        settingsImageView.tintColor = .theme.accent
    }
    
    private func addInvestmentLabelSetups() {
        investmentLabel.numberOfLines = 3
    }
    
    private func addProfitLabelSetups() {
        profitLabel.numberOfLines = 3
    }
    
    // MARK: - Helpers
    
    // MARK: Private
    
    private func modificatorForCoinLabel(_ symbol: String, _ name: String) -> NSMutableAttributedString {
        let firstAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.theme.title!,
            NSAttributedString.Key.font: UIFont.altone(17, .bold)
        ]
        let secondAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont.altone(15, .medium)
        ]
        
        let firstString = NSMutableAttributedString(string: "\(symbol.uppercased())/USD\n", attributes: firstAttributes)
        
        let secondString = NSAttributedString(string: "\(name)", attributes: secondAttributes)
        firstString.append(secondString)
        return firstString
    }
    
    private func modificatorForInvestmentLabel(_ invest: Int) -> NSMutableAttributedString {
        let firstAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont.altone(15, .medium)
        ]
        let secondAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.altone(16, .bold)
        ]
        
        let firstString = NSMutableAttributedString(string: "💰Investment\n", attributes: firstAttributes)
        
        let secondString = NSAttributedString(string: "$\(invest)\n", attributes: secondAttributes)
        let thirdString = NSAttributedString(string: "USDT", attributes: firstAttributes)
        firstString.append(secondString)
        firstString.append(thirdString)
        return firstString
    }
    
    private func modificatorForProfitLabel(_ targetPrice: Int, _ profit: String, _ change: String, _ color: UIColor) -> NSMutableAttributedString {
        let firstAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont.altone(15, .medium)
        ]
        
        let secondAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.altone(14, .bold)
        ]
        
        let thirdAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: UIFont.altone(12, .medium)
        ]
        
        let firstString = NSMutableAttributedString(string: "🥇Profit\n", attributes: firstAttributes)
        
        let secondString = NSAttributedString(string: "$\(profit)/$\(targetPrice)\n", attributes: secondAttributes)
        let thirdString = NSAttributedString(string: "\(change)", attributes: thirdAttributes)
        firstString.append(secondString)
        firstString.append(thirdString)
        return firstString
    }
}
