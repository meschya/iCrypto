import UIKit

class InvestTextField: UIStackView {
    // MARK: - Properties

    // MARK: Private
    
    private let label: UILabel = UILabel()
    private let textField: UITextField = UITextField()
    
    var text: String {
           get {
               textField.text ?? ""
           }
           set {
               textField.text = newValue
           }
       }

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
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.setUnderLine()
    }
    
    // MARK: - API
    
    func configurator(_ txt: String, _ type: UIKeyboardType = .default, _ image: String) {
        label.text = txt
        textField.keyboardType = type
        textField.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(systemName: image)
        imageView.image = image
        textField.leftView = imageView
    }
    
    // MARK: - Constraints
    
    // MARK: Private
    
    private func addContraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
    }
    
    // MARK: - Setups
    
    // MARK: Private
    
    private func addSubviews() {
        addArrangedSubviews(label,
                            textField)
    }
    
    private func addSetups() {
        addLabelSetups()
        addTextFieldSetups()
        spacing = 15
    }
    
    private func addLabelSetups() {
        label.font = .altone(20, .medium)
    }
    
    private func addTextFieldSetups() {
        textField.font = .altone(20, .medium)
        textField.spacing(size: 20)
    }
}
