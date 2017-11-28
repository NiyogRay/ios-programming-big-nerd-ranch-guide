import Foundation

class PhotoStore {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    /// create a URLRequest that connects to api.flickr.com and asks for the list of interesting photos
    func fetchInterestingPhotos() {
        
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            if let jsonData = data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    print(jsonObject)
                }
                catch {
                    print("Error creating JSON object: \(error)")
                }
            }
            else if let requestError = error {
                print("Error fetching interesting photos: \(requestError)")
            }
            else {
                print("Unexpected error with the request")
            }
        }
        task.resume()
    }
}
