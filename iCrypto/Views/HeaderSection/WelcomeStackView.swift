import CoreData
import UIKit

final class WelcomeStackView: UIStackView, NSFetchedResultsControllerDelegate {
    // MARK: - Properties
    
    // MARK: Public
    
    let tableHeaderStackView: TableHeaderStackView = .init()
    weak var delegate: TransferActionsBetweenVCDelegate?
    var invests: [Investment] = [] {
        didSet {
            setCount(invests.count)
            investmentCollectionView.reloadData()
        }
    }
    
    // MARK: Private
    
    private var fetchResultController: NSFetchedResultsController<Investment>!
    var coins: [CoinModel] = [] {
        didSet {
            investmentCollectionView.reloadData()
        }
    }
    private var profileFetchResultController: NSFetchedResultsController<Profile>!
    private var profiles: [Profile] = [] {
        didSet {
            setUserInfo()
            investmentCollectionView.reloadData()
        }
    }
    
    private let welcomeStackView: UIStackView = .init()
    private let welcomeLabel: UILabel = .init()
    private let personImageView: UIImageView = .init()
    private let countNotesLabel: UILabel = .init()
    private let investmentsStackView: UIStackView = .init()
    private let investmentsLabel: UILabel = .init()
    private let investmentsImageView: UIImageView = .init()
    private let investmentCollectionView: UICollectionView = .init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let layout = UICollectionViewFlowLayout()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addContraints()
        addSetups()
        profileCoreDataSetups()
        coreDataSetups()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [weak self] in
            self?.addPersonImageSetups()
        }
    }
    
    // MARK: - CoreData

    func coreDataSetups() {
        let fetchRequest: NSFetchRequest<Investment> = Investment.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "coinSymbol", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    invests = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - CoreData

    private func profileCoreDataSetups() {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            profileFetchResultController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            profileFetchResultController.delegate = self
            do {
                try profileFetchResultController.performFetch()
                if let fetchedObjects = profileFetchResultController.fetchedObjects {
                    profiles = fetchedObjects
                    print(profiles)
                }
            } catch {
                print(error)
            }
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
        addCountNotesLabelConstraint()
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
    
    private func addCountNotesLabelConstraint() {
        countNotesLabel.translatesAutoresizingMaskIntoConstraints = false
        countNotesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        countNotesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
    
    private func addTagCollectionViewConstraints() {
        investmentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        investmentCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        investmentCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        investmentCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
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
    
    func set(_ text: String, _ image: Data) {
        welcomeLabel.text = "Hello, \(text)!"
        personImageView.image = UIImage(data: image)
    }
    
    private func setCount(_ count: Int) {
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
                            investmentCollectionView,
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
        countNotesLabel.adjustsFontSizeToFitWidth = true
        countNotesLabel.minimumScaleFactor = 0.5
    }
    
    private func addWelcomeLabelSetups() {
        welcomeLabel.font = .altone(15, .light)
        welcomeLabel.textColor = .gray
    }
    
    private func addPersonImageSetups() {
        personImageView.layer.cornerRadius = personImageView.frame.size.width / 2
        personImageView.clipsToBounds = true
        personImageView.contentMode = .scaleAspectFill
    }
    
    private func addTagCollectionViewSetupsUI() {
        investmentCollectionView.backgroundColor = .systemBackground
        investmentCollectionView.collectionViewLayout = layout
        investmentCollectionView.showsHorizontalScrollIndicator = false
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 290, height: 190)
    }
    
    private func tagCollectionViewSetup() {
        investmentCollectionView.delegate = self
        investmentCollectionView.dataSource = self
        investmentCollectionView.register(InvestmentsCollectionViewCell.self, forCellWithReuseIdentifier: InvestmentsCollectionViewCell.identifier)
    }
    
    // MARK: - Helpers
    
    // MARK: Public
    
    func setUserInfo() {
        if !profiles.isEmpty {
        set(profiles[0].name ?? "Yegor", profiles[0].image ?? Data())
        } else {
            set("my Friend", Data())
        }
    }
    
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
        addInsvestmentVC.isEditingInvestment = false
        delegate?.viewScreen(addInsvestmentVC)
    }
}

extension WelcomeStackView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return invests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = investmentCollectionView.dequeueReusableCell(withReuseIdentifier: InvestmentsCollectionViewCell.identifier, for: indexPath) as? InvestmentsCollectionViewCell {
            for coin in coins {
                let invest = invests[indexPath.row]
                let changeColor = (coin.priceChangePercentage24H ?? 0.0 < 0)
                if invest.coinSymbol?.uppercased() == coin.symbol.uppercased() {
                    cell.set(invest.coinSymbol ?? "BTC",
                             invest.coinName ?? "Bitcoin",
                             invest.invest,
                             invest.targetPrice,
                             coin.priceChangePercentage24H?.asPercentString() ?? "0.0",
                             coin.currentPrice,
                             coin.image,
                             changeColor ? .systemRed : .systemGreen,
                             invest.buyingPrice)
                    cell.deleteHandler = { [weak self] in
                        self?.deleteCell(indexPath: indexPath)
                    }
                    cell.editHandler = { [weak self] in
                        self?.editCell(indexPath: indexPath)
                    }
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    // MARK: Fetch request methods

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = indexPath {
                investmentCollectionView.insertItems(at: [indexPath])
            }
        case .delete:
            if let indexPath = indexPath {
                investmentCollectionView.deleteItems(at: [indexPath])
            }
        case .update:
            if let indexPath = indexPath {
                investmentCollectionView.reloadItems(at: [indexPath])
            }
        default:
            investmentCollectionView.reloadData()
        }
        if let fetchedObjects = controller.fetchedObjects {
            invests = fetchedObjects as! [Investment]
        }
    }
    
    // MARK: Delete and Edit cell CollectionView
    
    private func deleteCell(indexPath: IndexPath) {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
        let context = appDelegate.persistentContainer.viewContext
        let investDelete = fetchResultController.object(at: indexPath)
        investmentCollectionView.deleteItems(at: [indexPath])
        context.delete(investDelete)
        appDelegate.saveContext()
    }
    
    private func editCell(indexPath: IndexPath) {
        let addInsvestmentVC = AddInvestmentsViewController()
        addInsvestmentVC.invest = invests[indexPath.item]
        addInsvestmentVC.isEditingInvestment = true
        delegate?.viewScreen(addInsvestmentVC)
    }
}
