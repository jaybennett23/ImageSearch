import UIKit

class SearchView: UIStackView {

    private enum Constants {
        static let titleLabelText = "Search For Photos"
        static let searchTextFieldPlaceholder = "Please search for an image"
        static let searchButtonText = "Search!"
        static let titleLabelFont = "Helvetica-Bold"
        static let padding: CGFloat = 16.0
        static let textFieldBorderWidth: CGFloat = 4.0
        static let titleLabelSize: CGFloat = 24.0

        static let searchViewAccessibilityIdentifier = "searchView"
        static let searchTextFieldAccessibilityIdentifier = "searchTextField"
        static let searchButtonAccessibilityIdentifier = "searchButton"
    }

    weak var delegate: SearchViewDelegate?

     var isSearchFieldEmpty: Bool {
        return searchTextField.text?.isEmpty ?? true
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleLabelText
        label.font = UIFont(name: Constants.titleLabelFont, size: Constants.titleLabelSize)
        label.textAlignment = .center
        label.accessibilityIdentifier = Constants.searchTextFieldAccessibilityIdentifier
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = Constants.textFieldBorderWidth
        textField.layer.borderColor = UIColor.systemPink.cgColor
        textField.layer.cornerRadius = Constants.padding
        textField.textAlignment = .center
        textField.placeholder = Constants.searchTextFieldPlaceholder
        textField.accessibilityIdentifier = Constants.searchTextFieldAccessibilityIdentifier
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.searchButtonText, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = .systemPink
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = Constants.searchButtonAccessibilityIdentifier
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        accessibilityIdentifier = Constants.searchViewAccessibilityIdentifier
        prepareView()
    }

    private func prepareView() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(searchTextField)
        addArrangedSubview(searchButton)

        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        spacing = Constants.padding
        isLayoutMarginsRelativeArrangement = true
    }

    @objc private func searchButtonTapped() {
        delegate?.searchButtonTapped()
    }
}

protocol SearchViewDelegate: AnyObject {
    func searchButtonTapped()
}
