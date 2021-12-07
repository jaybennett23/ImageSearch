import Foundation
import UIKit

class GalleryViewModel {
    var photoUrls: [Photo] = []
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = ConcreteNetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchPhotosFromAPI(searchTerms: String, completed: @escaping (String) -> Void) {
        networkManager.fetchPhotoInfoFromAPI(searchTerms: searchTerms) { result in

            switch result {
            case .success(let photos):
                guard let photos = photos else { return }
                self.photoUrls.append(contentsOf: photos.hits)
                completed("")
            case .failure(let error):
                completed(error.rawValue)
            }
        }
    }
}
