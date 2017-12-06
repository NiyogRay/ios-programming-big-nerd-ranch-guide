import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var viewCountLabel: UILabel!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    
    // MARK: - View cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the image when the view is loaded
        store.fetchImage(for: photo) { (imageResult) in
            switch imageResult {
            case let .success(image):
                self.imageView.image = image
                
                // https://forums.bignerdranch.com/t/solution-for-ch-22-bronze-challenge-photo-view-count/11408
                self.photo.viewCount += 1
                self.store.saveContextIfNeeded()
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
            
            self.showViewCount()
        }
    }
    
    func showViewCount() {
        viewCountLabel.text = (photo.viewCount == 1 ? "1 view" : "\(photo.viewCount) views")
    }
}
