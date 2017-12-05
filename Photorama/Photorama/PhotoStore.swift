import UIKit
import CoreData

/// the result of downloading an image
enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

/// photo errors
enum PhotoError: Error {
    case imageCreationError
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    
    let imageStore = ImageStore()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Photorama")
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error))")
            }
        })
        return container
    }()
    
    //MARK: - URLSession
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    /// create a URLRequest that connects to api.flickr.com and asks for the list of interesting photos
    func fetchPhotos(ofType photoType: PhotoType, completion: @escaping (PhotosResult) -> Void) {
        
        let url: URL!
        if photoType == .interesting {
            url = FlickrAPI.interestingPhotosURL
        }
        else {
            url = FlickrAPI.recentPhotosURL
        }
        
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            guard let httpResponse = response as! HTTPURLResponse?
            else {
                return
            }
            
            print("Flickr Photos Response")
            print("Status Code: \(httpResponse.statusCode)")
            print("Header Fields: \(httpResponse.allHeaderFields)")
            
            var result = self.processPhotosRequest(data: data, error: error)
            
            if case .success = result {
                do {
                    try self.persistentContainer.viewContext.save()
                }
                catch let error {
                    result = .failure(error)
                }
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    /// download the image data
    func fetchImage(for photo: Photo,
                    completion: @escaping (ImageResult) -> Void) {
        
        
        guard let photoKey = photo.id
        else {
            preconditionFailure("Photo expected to have an id")
        }
        // if image is already present in imageStore,
        // load and return
        if let image = imageStore.image(forKey: photoKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        
        guard let photoURL = photo.remoteURL
        else {
            preconditionFailure("Photo expected to have a remoteURL")
        }
        let request = URLRequest(url: photoURL as URL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            guard let httpResponse = response as! HTTPURLResponse?
                else {
                    return
            }
            print("Flickr Photo Response")
            print("Status Code: \(httpResponse.statusCode)")
            print("Header Fields: \(httpResponse.allHeaderFields)")
            
            let result = self.processImageRequest(data: data, error: error)
            
            // save the image using the imageStore
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    // MARK: - Data Processing
    
    /// processes the data from the webservice request into an array of Photo objects
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard
            let jsonData = data
            else {
                return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData,
                                into: persistentContainer.viewContext)
    }
    
    /// processes the data from the webservice request into an image
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard
            let imageData = data,
            let image = UIImage(data: imageData)
            else {
                
                // Couldnt create an image
                if data == nil {
                    return .failure(error!)
                }
                else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
        return .success(image)
    }
}
