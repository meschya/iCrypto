import UIKit
import CoreData

final class InfoView: UIView, NSFetchedResultsControllerDelegate {
    // MARK: - Properties
    
    // MARK: Private

    private var profileFetchResultController: NSFetchedResultsController<Profile>!
    private var profiles: [Profile] = []
    private var profile: Profile = .init()
    private var personImage: UIImage = .init()
    private let mainStackView: UIStackView = .init()
    private let nameTextField: InfoTextField = .init()
    private let phoneNumberTextField: InfoTextField = .init()
    private let dateTextField: InfoTextField = .init()
    private let saveButton: UIButton = .init()
    private let datePicker: UIDatePicker = .init()
    
    // MARK: - LIfecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addSetups()
        addContraints()
        coreDataSetups()
        addInfo()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CoreData

    private func coreDataSetups() {
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
                }
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Constraints
    
    // MARK: Private
    
    private func addContraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    // MARK: - Setups
    
    // MARK: Private
    
    private func addSubviews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubviews(nameTextField,
                                          phoneNumberTextField,
                                          dateTextField,
                                          saveButton)
    }
    
    private func addSetups() {
        addMainStackViewSetups()
        addTextFieldsSetups()
        addSaveButtonSetups()
        createDatePicker()
    }
    
    private func addMainStackViewSetups() {
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 20
    }
    
    private func addTextFieldsSetups() {
        nameTextField.configurator("person.fill", "Name")
        nameTextField.isAutoCorrectionEnabled = false
        phoneNumberTextField.configurator("phone.fill", "Number phone", .phonePad)
    }
    
    private func addSaveButtonSetups() {
        saveButton.backgroundColor = .theme.cellColor
        saveButton.addShadow()
        saveButton.layer.cornerRadius = 15
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = .altone(18, .bold)
        saveButton.addTarget(self, action: #selector(saveNamegiver), for: .touchUpInside)
    }
    
    private func createDatePicker() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.datePickerMode = .date
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonClick))
        doneBtn.tintColor = .systemOrange
        toolBar.setItems([doneBtn], animated: true)
        dateTextField.date("calendar", toolbar: toolBar, inputView: datePicker)
        dateTextField.text = formatter(.medium).string(from: datePicker.date)
    }
    
    // MARK: - Helpers
    
    // MARK: Private
    
    private func isEmptyFields() -> Bool {
        if nameTextField.text != "",
           phoneNumberTextField.text != "",
           dateTextField.text != ""
        {
            return false
        }
        return true
    }
    
    private func formatter(_ style: DateFormatter.Style) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.timeStyle = .none
        return formatter
    }
    
    private func showAllert(_ msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    
    private func addInfo() {
        if profiles.count == 0 {
            nameTextField.text = ""
            phoneNumberTextField.text = ""
        } else if profiles.count != 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM"
            nameTextField.text = profiles[0].name ?? "Yegor"
            phoneNumberTextField.text = profiles[0].phoneNumber ?? "+375298033970"
            PersonImageStackView.image = UIImage(data: profiles[0].image!)!
            dateTextField.text = formatter(.medium).string(from: profiles[0].date ?? Date())
        }
    }
    
    // MARK: - Actions
    
    // MARK: Private
    
    @objc private func doneButtonClick() {
        dateTextField.text = formatter(.medium).string(from: datePicker.date)
        endEditing(true)
    }
    
    @objc func saveNamegiver() {
        personImage = PersonImageStackView.image
        let date = formatter(.medium).date(from: dateTextField.text)!
        if isEmptyFields() == false {
            if profiles.count == 0 {
                CoreDataManager.instance.saveProfile(profile,
                                                     nameTextField.text,
                                                     phoneNumberTextField.text,
                                                     date,
                                                     personImage)
            } else if profiles.count != 0 {
                profiles[0].name = nameTextField.text
                profiles[0].phoneNumber = phoneNumberTextField.text
                profiles[0].date = date
                profiles[0].image = personImage.pngData()
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    appDelegate.saveContext()
                }
            }
        } else {
            print("Please fill in all fields!")
        }
    }
}
