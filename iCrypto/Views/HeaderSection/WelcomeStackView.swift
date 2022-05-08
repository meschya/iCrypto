import UIKit

enum Tags: String {
    case work = "Работа"
    case study = "Учёба"
    case eat = "Еда"
    case sport = "Спорт"
    case other = "Другое"
    
    static let allValues = [work, study, eat, sport, other]
}

final class WelcomeStackView: UIStackView {
    // MARK: - Properties
    
    // MARK: Public
    
    let tableHeaderStackView: TableHeaderStackView = .init()
    weak var delegate: TransferActionsBetweenVCDelegate?
    
    // MARK: Private
    
    private let welcomeStackView: UIStackView = .init()
    private let welcomeLabel: UILabel = .init()
    private let personImageView: UIImageView = .init()
    private let countNotesLabel: UILabel = .init()
    private let investmentsStackView: UIStackView = .init()
    private let investmentsLabel: UILabel = .init()
    private let investmentsImageView: UIImageView = .init()
    private let tagCollectionView: UICollectionView = .init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let layout = UICollectionViewFlowLayout()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addContraints()
        addSetups()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.addPersonImageSetups()
        }
    }

    // MARK: - Constraints
    
    // MARK: Private
    
    private func addContraints() {
        addPersonImageViewConstraints()
        addTagCollectionViewConstraints()
        addWelcomeStackViewConstraint()
        addTableHeaderStackViewConstraints()
        addInvestmentsImageViewConstraints()
    }
    
    private func addPersonImageViewConstraints() {
        personImageView.translatesAutoresizingMaskIntoConstraints = false
        personImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        personImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        personImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func addWelcomeStackViewConstraint() {
        welcomeStackView.translatesAutoresizingMaskIntoConstraints = false
        welcomeStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        welcomeStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
    }
    
    private func addTagCollectionViewConstraints() {
        tagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tagCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tagCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tagCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func addTableHeaderStackViewConstraints() {
        tableHeaderStackView.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        tableHeaderStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
    }
    
    private func addInvestmentsImageViewConstraints() {
        investmentsImageView.translatesAutoresizingMaskIntoConstraints = false
        investmentsImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        investmentsImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        investmentsImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    // MARK: - API
    
    func set(_ text: String, _ image: String) {
        welcomeLabel.text = "Добро пожаловать, \(text)!"
        personImageView.image = UIImage(named: image)
    }
    
    func setCount(_ count: Int) {
        countNotesLabel.attributedText = modificatorForCountNotesLabel(count)
    }
    
    // MARK: - Setups
    
    // MARK: Private
    
    private func addSubviews() {
        addArrangedSubview(welcomeStackView)
        welcomeStackView.addArrangedSubviews(welcomeLabel,
                                             personImageView)
        addArrangedSubviews(countNotesLabel,
                            investmentsStackView,
                            tagCollectionView,
                            tableHeaderStackView)
        investmentsStackView.addArrangedSubviews(investmentsLabel,
                                                 investmentsImageView)
    }
    
    private func addSetups() {
        addStackViewSetups()
        addWelcomeLabelSetups()
        addWelcomeStackViewSetups()
        addInvestmentsStackViewSetups()
        addInvestmentsLabelSetups()
        addInvestmentsImageViewSetups()
        addCountNotesLabelSetups()
        addTagCollectionViewSetupsUI()
        tagCollectionViewSetup()
    }
    
    private func addStackViewSetups() {
        axis = .vertical
        alignment = .fill
        distribution = .fillProportionally
        backgroundColor = .systemBackground
        spacing = 10
    }
    
    private func addWelcomeStackViewSetups() {
        welcomeStackView.axis = .horizontal
        welcomeStackView.alignment = .fill
        welcomeStackView.distribution = .fillProportionally
    }
    
    private func addInvestmentsStackViewSetups() {
        investmentsStackView.axis = .horizontal
        investmentsStackView.alignment = .fill
        investmentsStackView.distribution = .fillProportionally
    }
    
    private func addInvestmentsImageViewSetups() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(addInsvestmentsClick))
        investmentsImageView.isUserInteractionEnabled = true
        investmentsImageView.image = UIImage(systemName: "plus.circle.fill")
        investmentsImageView.tintColor = .theme.accent
        investmentsImageView.addGestureRecognizer(tap)
    }
    
    private func addInvestmentsLabelSetups() {
        investmentsLabel.text = "My Investments"
        investmentsLabel.font = .altone(20, .medium)
    }
    
    private func addCountNotesLabelSetups() {
        countNotesLabel.attributedText = modificatorForCountNotesLabel()
        countNotesLabel.numberOfLines = 2
    }
    
    private func addWelcomeLabelSetups() {
        welcomeLabel.text = "Hello, Yegor!"
        welcomeLabel.font = .altone(15, .light)
        welcomeLabel.textColor = .gray
    }
    
    private func addPersonImageSetups() {
        personImageView.image = UIImage(named: "6")
        personImageView.layer.cornerRadius = personImageView.frame.size.width / 2
        personImageView.clipsToBounds = true
        personImageView.contentMode = .scaleAspectFill
    }
    
    private func addTagCollectionViewSetupsUI() {
        tagCollectionView.backgroundColor = .systemBackground
        tagCollectionView.collectionViewLayout = layout
        tagCollectionView.showsHorizontalScrollIndicator = false
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 290, height: 190)
    }
    
    private func tagCollectionViewSetup() {
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.register(InvestmentsCollectionViewCell.self, forCellWithReuseIdentifier: InvestmentsCollectionViewCell.identifier)
    }
    
    // MARK: - Helpers
    
    // MARK: Private
    
    private func modificatorForCountNotesLabel(_ count: Int = 0) -> NSMutableAttributedString {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        let firstAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.theme.title!,
            NSAttributedString.Key.font: UIFont.altone(30, .bold)
        ]
        let secondAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.theme.accent!,
            NSAttributedString.Key.font: UIFont.altone(30, .bold)
        ]
        
        let firstString = NSMutableAttributedString(string: "You have ", attributes: firstAttributes)
        
        let secondString = NSAttributedString(string: "\(count) investments ", attributes: secondAttributes)
        let thirdString = NSAttributedString(string: "for \(dateFormatter.string(from: Date())) 👍🏻", attributes: firstAttributes)
        firstString.append(secondString)
        firstString.append(thirdString)
        return firstString
    }
    
    // MARK: - Actions
    
    // MARK: Private
    
    @objc private func addInsvestmentsClick() {
        let addInsvestmentVC = AddInvestmentsViewController()
        delegate?.viewScreen(addInsvestmentVC)
    }
}

extension WelcomeStackView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Tags.allValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: InvestmentsCollectionViewCell.identifier, for: indexPath) as? InvestmentsCollectionViewCell {
            //cell.set(Tags.allValues[indexPath.item].rawValue)
            return cell
        }
        return UICollectionViewCell()
    }
}
