import UIKit

class GalleryViewController: UIViewController {

    private var searchTerms: String
    private var photoUrls: [Photo] = []
    private let networkManager: NetworkManager
    private let viewModel: GalleryViewModel

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: CollectionViewLayoutHelper.createTwoColumnFlowLayout(in: view))
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.reuseId)
        collectionView.backgroundColor = .systemGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        return collectionView
    }()

    init(searchTerms: String, networkManager: NetworkManager, viewModel: GalleryViewModel) {
        self.searchTerms = searchTerms
        self.networkManager = networkManager
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotoFromAPI()
        prepareView()
    }

    private func prepareView() {
        view.backgroundColor = .systemGray
        view.accessibilityIdentifier = "GalleryScreen"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false

        view.addSubview(collectionView)
    }

    private func fetchPhotoFromAPI() {

        viewModel.fetchPhotosFromAPI(searchTerms: searchTerms) { _ in
            if self.viewModel.photoUrls.count == 0 {
                self.presentAlert(title: .alertTitle, message: .alertMessage, buttonTitle: nil)
                return
            }

            DispatchQueue.main.async { self.collectionView.reloadData() }
        }
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.reuseId,
                                                            for: indexPath) as? GalleryCell else {
            fatalError("Unable to dequeue cell")
        }

        cell.setAndCacheImage(from: viewModel.photoUrls[indexPath.row].largeImageURL, networkManager: networkManager)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoUrls.count
    }
}

private extension String {
    static let alertTitle = "Oh no!"
    static let alertMessage = "Something has went wrong 😞. Please try again!"
}
