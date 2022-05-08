import UIKit

final class AddInvestmentsViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: Private
    
    private let scrollView: UIScrollView = .init()
    private let mainStackView: UIStackView = .init()
    private let coinStackView: UIStackView = .init()
    private let coinLabel: UILabel = .init()
    private let coinTextField: UITextField = .init()
    private let coinPickerView: UIPickerView = UIPickerView()
    private let investTextField: InvestTextField = .init()
    private let targetTextField: InvestTextField = .init()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addSetups()
        addContraints()
        scrollView.showsVerticalScrollIndicator = false
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Constraints
    
    // MARK: Private
    
    private func addContraints() {
        addScrollViewConstraints()
        addMainStackViewConstraints()
        addCoinLabelConstraints()
    }
    
    private func addScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
    }
    
    private func addMainStackViewConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        mainStackView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
    }
    
    private func addCoinLabelConstraints() {
        coinLabel.translatesAutoresizingMaskIntoConstraints = false
        coinLabel.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.2).isActive = true
    }
    
    // MARK: - Setups
    
    // MARK: Private
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubviews(coinStackView,
                                          investTextField,
                                          targetTextField)
        coinStackView.addArrangedSubviews(coinLabel,
                                          coinTextField)
    }
    
    private func addSetups() {
        configNavigationBar()
        addCoinLabelSetups()
        addCoinTextFieldSetups()
        addMainStackViewSetups()
        addCoinStackViewSetups()
        addInvestTextFieldSetups()
        addTargetTextFieldSetups()
    }
    
    private func configNavigationBar() {
        title = "Investments"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self,
            action: nil
        )
    }
    
    private func addMainStackViewSetups() {
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.alignment = .fill
        mainStackView.spacing = 10
    }
    
    private func addCoinStackViewSetups() {
        coinStackView.axis = .horizontal
        coinStackView.distribution = .fillProportionally
        coinStackView.alignment = .fill
    }
    
    private func addCoinLabelSetups() {
        coinLabel.text = "Coin"
        coinLabel.font = .altone(20, .medium)
    }
    
    private func addCoinTextFieldSetups() {
        coinTextField.text = "BTC"
        coinTextField.font = .altone(15, .medium)
        coinTextField.layer.borderColor = UIColor.gray.cgColor
        coinTextField.layer.borderWidth  = 1
    }
    
    private func addInvestTextFieldSetups() {
        investTextField.configurator("Invest", .numberPad, "dollarsign.circle")
    }
    
    private func addTargetTextFieldSetups() {
        targetTextField.configurator("Target", .numberPad, "dollarsign.circle")
    }
}
