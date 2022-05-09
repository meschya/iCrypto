import CoreData
import UIKit

final class AddInvestmentsViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: Public
    
    var coins: [CoinModel] = [] {
        didSet {
            coinPickerView.reloadAllComponents()
        }
    }
    
    // MARK: Private
    
    private var invest: Investment = .init()
    private var nameCoin: String?
    private var priceCoin: Double?
    private let scrollView: UIScrollView = .init()
    private let mainStackView: UIStackView = .init()
    private let coinStackView: UIStackView = .init()
    private let coinLabel: UILabel = .init()
    private let coinTextField: UITextField = .init()
    private let investTextField: InvestTextField = .init()
    private let targetTextField: InvestTextField = .init()
    private let coinPickerView: UIPickerView = .init()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addSetups()
        addContraints()
        scrollView.showsVerticalScrollIndicator = false
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.coinTextField.setUnderLine()
        }
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
        createPicker()
    }
    
    private func configNavigationBar() {
        title = "Investments"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self,
            action: #selector(saveButtonTapped)
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
        coinStackView.spacing = 15
    }
    
    private func addCoinLabelSetups() {
        coinLabel.text = "Coin"
        coinLabel.font = .altone(20, .medium)
    }
    
    private func addCoinTextFieldSetups() {
        coinTextField.text = "BTC"
        coinTextField.font = .altone(20, .medium)
        coinTextField.leftViewMode = .always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(systemName: "bitcoinsign.circle")
        imageView.image = image
        coinTextField.leftView = imageView
    }
    
    private func addInvestTextFieldSetups() {
        investTextField.configurator("Invest", .numberPad, "dollarsign.circle")
    }
    
    private func addTargetTextFieldSetups() {
        targetTextField.configurator("Target", .numberPad, "dollarsign.circle")
    }
    
    // MARK: - Helpers
    
    // MARK: Private
    
    private func createPicker() {
        coinPickerView.delegate = self
        coinPickerView.dataSource = self
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBtn))
        doneBtn.tintColor = .theme.accent
        toolBar.backgroundColor = .theme.background
        toolBar.setItems([doneBtn], animated: true)
        coinTextField.inputAccessoryView = toolBar
        coinTextField.inputView = coinPickerView
    }
    
    private func saveInvestInfo() {
        CoreDataManager.instance.saveInvestment(invest,
                                                coinTextField.text ?? "BTC",
                                                nameCoin ?? "Bitcoin",
                                                Double(investTextField.text) ?? 0.0,
                                                Double(targetTextField.text) ?? 0.0,
                                                priceCoin ?? 0.0)
        navigationController?.popViewController(animated: true)
    }
    
    private func voidСheck() -> Bool {
        let checkAllInformation: Bool = (
            coinTextField.text != ""
                && investTextField.text != ""
                && nameCoin != nil
                && targetTextField.text != ""
        )
        return checkAllInformation
    }
    
    // MARK: - Actions
    
    // MARK: Private
    
    @objc private func doneBtn() {
        coinTextField.endEditing(true)
    }
    
    @objc private func saveButtonTapped() {
        if voidСheck() == true {
            saveInvestInfo()
        } else {
            showAllert("Fill in all fields")
        }
    }
    
    private func showAllert(_ msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension AddInvestmentsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coins.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coins[row].symbol.uppercased()
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinTextField.text = coins[row].symbol.uppercased()
        nameCoin = coins[row].name
        priceCoin = coins[row].currentPrice
    }
}
