import UIKit

class GalleryCell: UICollectionViewCell {

    private enum Constants {
        static let padding: CGFloat = 8.0
        static let cornerRadius: CGFloat = 10.0
        static let reuseId = "GalleryCell"
        static let placeholderImage = UIImage(named: "PlaceholderImage")
    }

    static let reuseId = Constants.reuseId

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        view.image = Constants.placeholderImage
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.padding),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }

    func setAndCacheImage(from urlString: String, networkManager: NetworkManager) {
        networkManager.downloadAndCacheImage(from: urlString) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.imageView.image = image}
        }
    }
}
