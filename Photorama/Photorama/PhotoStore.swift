import Foundation

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    
    //MARK: - URLSession
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    /// create a URLRequest that connects to api.flickr.com and asks for the list of interesting photos
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processPhotosRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    // MARK: - Photos processing
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard
            let jsonData = data
            else {
                return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData)
    }
}
