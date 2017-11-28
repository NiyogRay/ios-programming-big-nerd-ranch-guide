import UIKit

/// segments for the segmented control
enum PhotoType: Int {
    case interesting = 0
    case recent = 1
}

class PhotosViewController: UIViewController {
    
    @IBOutlet var photoTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo) { (imageResult) in
            
            switch imageResult {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        }
    }
    
    // MARK: - Fetch Photo
    
    func fetchPhoto(ofType photoType: PhotoType) {
        
        /// download the image data for the first photo that is returned from the interesting photos request and display it on the image view
        store.fetchPhotos(ofType: photoType,
                          completion: { (photosResult) in
            
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos")
                if let firstPhoto = photos.first {
                    self.updateImageView(for: firstPhoto)
                }
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
        })
    }
    
    // MARK: - Actions
    
    @IBAction func photoTypeSelected(_ sender: UISegmentedControl) {
        
        let photoType = PhotoType(rawValue: sender.selectedSegmentIndex)!
        fetchPhoto(ofType: photoType)
    }
}
