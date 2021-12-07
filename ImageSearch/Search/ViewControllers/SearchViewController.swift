import UIKit

class SearchViewController: UIViewController {

    private enum Constants {
        static let searchViewYAxisOffset: CGFloat = 48.0
        static let searchViewHeight: CGFloat = 225.0
        static let searchViewWidth: CGFloat = 275.0

        static let alertTitle = "Oh no!"
        static let alertMessage = "We can't search for images without any text 😞."

        static let searchScreenAccessibilityIdentifier = "searchViewController"
    }

    private lazy var searchView: SearchView = {
        let view = SearchView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
    }

    private func prepareView() {
        view.backgroundColor = .systemGray
        view.addSubview(searchView)
        view.accessibilityIdentifier = Constants.searchScreenAccessibilityIdentifier

        NSLayoutConstraint.activate([
            searchView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -Constants.searchViewYAxisOffset),
            searchView.heightAnchor.constraint(equalToConstant: Constants.searchViewHeight),
            searchView.widthAnchor.constraint(equalToConstant: Constants.searchViewWidth)
        ])
    }
}

extension SearchViewController: SearchViewDelegate {
    func searchButtonTapped() {
        guard !searchView.isSearchFieldEmpty else {
            presentAlert(title: Constants.alertTitle,
                         message: Constants.alertMessage,
                         buttonTitle: nil)
            return
        }

        guard let searchTerms = searchView.searchTextField.text else { return }

        let galleryViewController = GalleryViewController(searchTerms: searchTerms, networkManager: ConcreteNetworkManager(), viewModel: GalleryViewModel())
        galleryViewController.title = searchView.searchTextField.text
        navigationController?.pushViewController(galleryViewController, animated: true)
    }
}
