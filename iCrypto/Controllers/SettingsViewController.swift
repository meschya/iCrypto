import UIKit

final class SettingsViewController: UIViewController {
    // MARK: - Properties

    // MARK: Private

    private let scrollView: UIScrollView = .init()
    private let mainStackView: UIStackView = .init()
    private let profileLabel: UILabel = .init()
    private let personImage: PersonImageStackView = .init()
    private let infoView: InfoView = .init()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addSetups()
        addContraints()
    }
    
    // MARK: - Constraints
    
    // MARK: Private
    
    private func addContraints() {
        addScrollViewConstraints()
        addMainStackViewConstraints()
        addPersonImageAndInfoHeightConstraints()
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
        mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 70).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        mainStackView.heightAnchor.constraint(equalToConstant: 535).isActive = true
        mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
    }
    
    private func addPersonImageAndInfoHeightConstraints() {
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        personImage.translatesAutoresizingMaskIntoConstraints = false
        personImage.heightAnchor.constraint(equalToConstant: 190).isActive = true
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.heightAnchor.constraint(equalToConstant: 310).isActive = true
    }
    
    // MARK: - Setups
    
    // MARK: Private
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubviews(profileLabel,
                                          personImage,
                                          infoView)
    }
    
    private func addSetups() {
        view.backgroundColor = .systemBackground
        addMainStackViewSetups()
        addProfileLabelSetups()
    }
    
    private func addMainStackViewSetups() {
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillProportionally
        mainStackView.alignment = .fill
        mainStackView.spacing = 30
    }
    
    private func addProfileLabelSetups() {
        profileLabel.text = "Your Profile 👽"
        profileLabel.font = .altone(35, .bold)
    }
}
