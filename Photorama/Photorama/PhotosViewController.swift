import UIKit

enum PhotoType: Int {
    case interesting = 0
    case recent = 1
}

class PhotosViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var photoType: PhotoType!
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    // MARK: - View cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchPhoto(ofType: photoType)
    }
    
    // MARK: - Setup
    
    func setupTabBarItem() {
    
        let tabBarSystemItem: UITabBarSystemItem
        switch photoType! {
        case PhotoType.interesting:
            tabBarSystemItem = UITabBarSystemItem.featured
        case PhotoType.recent:
            tabBarSystemItem = UITabBarSystemItem.recents
        }
        
        tabBarItem = UITabBarItem(tabBarSystemItem: tabBarSystemItem, tag: photoType!.rawValue)
    }
    
    // MARK: - Fetch Photo
    
    func fetchPhoto(ofType photoType: PhotoType) {
        
        /// download the image data for the first photo that is returned from the interesting photos request and display it on the image view
        store.fetchPhotos(ofType: photoType) {
            (photosResult) in
            
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos")
                self.photoDataSource.photos = photos
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
}
