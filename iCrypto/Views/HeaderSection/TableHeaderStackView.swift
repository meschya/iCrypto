import UIKit

final class TableHeaderStackView: UIStackView {
    // MARK: - Properties
    
    // MARK: Private
    
    private let coinLabel: UILabel = .init()
    private let priceLabel: UILabel = .init()
    private let timelineLabel: UILabel = .init()
    
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
        addDateLabelConstraints()
        addPriceLabelConstraints()
        //addAddImageViewConstraints()
    }
    
    private func addDateLabelConstraints() {
        coinLabel.translatesAutoresizingMaskIntoConstraints = false
        coinLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15).isActive = true
    }
    
    private func addPriceLabelConstraints() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
    }
    
    // MARK: - Setups
    
    // MARK: Private
    
    private func addSubviews() {
        addArrangedSubviews(coinLabel,
                            timelineLabel,
                            priceLabel)
    }
    
    private func addSetups() {
        addDateLabelSetups()
        addNotesLabelSetups()
        addStackViewSetups()
        addTimelineLabelSetups()
    }
    
    private func addStackViewSetups() {
        spacing = 20
    }
    
    private func addDateLabelSetups() {
        coinLabel.text = "Coin"
        coinLabel.font = .altone(15, .regular)
        coinLabel.textAlignment = .left
        coinLabel.textColor = .gray
    }
    
    private func addTimelineLabelSetups() {
        timelineLabel.text = "Timeline"
        timelineLabel.font = .altone(15, .regular)
        timelineLabel.textAlignment = .right
        timelineLabel.textColor = .gray
    }
    
    private func addNotesLabelSetups() {
        priceLabel.text = "Price"
        priceLabel.textAlignment = .right
        priceLabel.font = .altone(15, .regular)
        priceLabel.textColor = .gray
    }
}
