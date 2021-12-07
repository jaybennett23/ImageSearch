import UIKit

public protocol NetworkManager: AnyObject {
    func fetchPhotoInfoFromAPI(searchTerms: String, completed: @escaping (Result<SearchResult?, ImageSearchError>) -> Void)
    func downloadAndCacheImage(from urlString: String, completed: @escaping (UIImage) -> Void)
}

class ConcreteNetworkManager: NetworkManager {

    private let baseURL = "https://pixabay.com/api/?key=13197033-03eec42c293d2323112b4cca6&q"
    private let urlSuffix = "&image_type=photo&pretty=true"
    private let cache = NSCache<NSString, UIImage>()

    init() {}

    func fetchPhotoInfoFromAPI(searchTerms: String, completed: @escaping (Result<SearchResult?, ImageSearchError>) -> Void) {
        let formattedSearchTerms = searchTerms.replacingOccurrences(of: " ", with: "+")
        let endPoint = baseURL + "=\(formattedSearchTerms)" + urlSuffix

        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidUrl))
            return
        }

        let _ = URLSession.shared.dataTask(with: url) { data, response, error in

            if let _ = error {
                completed(.failure(.invalidResponse))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.unableToComplete))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let photoInfo = try decoder.decode(SearchResult.self, from: data)
                completed(.success(photoInfo))
            } catch {
                completed(.failure(.invalidData))
            }
        }.resume()
    }

    func downloadAndCacheImage(from urlString: String, completed: @escaping (UIImage) -> Void) {

        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }

        guard let URL = URL(string: urlString) else { return }

        let _ = URLSession.shared.dataTask(with: URL) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }

            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }.resume()
    }
}
