import UIKit

final class WalletStackView: UIStackView {
    // MARK: - Properties
    
    // MARK: Private
    
    private let walletLabel: UILabel = .init()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addSetups()
        addContraints()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Constraints
    
    // MARK: Private
    
    private func addContraints() {
        walletLabel.translatesAutoresizingMaskIntoConstraints = false
        walletLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
    }
    
    // MARK: - Setups
    
    // MARK: Private
    
    private func addSubviews() {
        addArrangedSubview(walletLabel)
    }
    
    private func addSetups() {
        walletLabel.text = "Your wallet 💳"
        walletLabel.font = .altone(35, .bold)
    }
}
