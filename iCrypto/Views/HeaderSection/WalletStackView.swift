import UIKit

final class WalletStackView: UIStackView {
    // MARK: - Properties
    
    // MARK: Private
    
    private let barChartView: CryptoBarChartView = .init()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    // MARK: Private
    
    private func addSubviews() {
        addArrangedSubview(barChartView)
    }
    
    private func addSetups() {
        
    }
}
