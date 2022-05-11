import UIKit

final class WalletTableViewCell: UITableViewCell {
    // MARK: - Identifier
    
    static let identifier = "WalletTableViewCell"
    
    // MARK: - Properties

    // MARK: Public
    
    let walletView: WalletView = WalletView()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        addContraints()
        addSetups()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Constraints
    
    // MARK: Private
    
    private func addContraints() {
        walletView.translatesAutoresizingMaskIntoConstraints = false
        walletView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        walletView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        walletView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        walletView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    // MARK: - Setups
    
    // MARK: Private
    
    private func addSubviews() {
        contentView.addSubview(walletView)
    }
    
    private func addSetups() {
        contentView.backgroundColor = .systemBackground
    }
}
