import Foundation
import CoreData

/// FLickr API errors
enum FlickrError: Error {
    case invalidJSONData
}

/// Flickr Photo APIs
enum Method: String {
    case interestingPhotos = "flickr.interestingness.getList"
    case recentPhotos = "flickr.photos.getRecent"
}

struct FlickrAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private static func flickrURL(method: Method,
                                  parameters: [String: String]?) -> URL {
        
        var components = URLComponents(string: baseURLString)!
        
        // Create queryItems
        var queryItems = [URLQueryItem]()
        
        // Add baseParams
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
        ]
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        // Add additionalParams
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        // URL from components
        return components.url!
    }
    
    static var interestingPhotosURL: URL {
        return flickrURL(method: .interestingPhotos, parameters: ["extras" : "url_h, date_taken"])
    }
    
    static var recentPhotosURL: URL {
        return flickrURL(method: .recentPhotos, parameters: ["extras" : "url_h, date_taken"])
    }
    
    // MARK: - JSON
    
    private static func photo(fromJSON json: [String: Any],
                              ofType photoType: PhotoType,
                              into context: NSManagedObjectContext) -> Photo? {
        guard
            let id = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoURLString = json["url_h"] as? String,
            let url = URL(string: photoURLString),
            let dateTaken = dateFormatter.date(from: dateString)
            else {
                
                // Dont have enough information to construct Photo
                return nil
        }
        
        // check if there is an existing photo with a given ID
        // before inserting a new one.
        
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "\(#keyPath(Photo.id)) == \(id)")
        fetchRequest.predicate = predicate
        
        var fetchedPhotos: [Photo]?
        context.performAndWait {
            fetchedPhotos = try? fetchRequest.execute()
        }
        if let existingPhoto = fetchedPhotos?.first {
            return existingPhoto
        }
        
        var photo: Photo!
        context.performAndWait {
            photo = Photo(context: context)
            photo.title = title
            photo.id = id
            photo.remoteURL = url as NSURL
            photo.dateTaken = dateTaken as NSDate
            photo.type = Int16(photoType.rawValue)
        }
        
        return photo
    }
    
    // MARK: - GET
    
    static func photos(fromJSON data: Data,
                       ofType photoType: PhotoType,
                       into context: NSManagedObjectContext) -> PhotosResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard
                let jsonDictionary = jsonObject as? [AnyHashable: Any],
                let photos = jsonDictionary["photos"] as? [String: Any],
                let photosArray = photos["photo"] as? [[String: Any]]
            else {
                
                // The JSON structure doesnt match our expectations
                return .failure(FlickrError.invalidJSONData)
            }
            
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photo(fromJSON: photoJSON,
                                     ofType: photoType,
                                     into: context) {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.isEmpty && !photosArray.isEmpty {
                // We werent able to parse any of the photos
                // Maybe the JSON format for photos has changed
                return .failure(FlickrError.invalidJSONData)
            }
            return .success(finalPhotos)
        }
        catch {
            return .failure(error)
        }
    }
}
