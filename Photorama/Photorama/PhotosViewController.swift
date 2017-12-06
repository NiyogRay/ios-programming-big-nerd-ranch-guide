import UIKit

enum PhotoType: Int {
    case interesting = 0
    case recent = 1
}

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var photoType: PhotoType!
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    let collectionViewSectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    
    // MARK: - View cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        updateDataSource()
        
        store.fetchPhotos(ofType: photoType) {
            (photosResult) in
            
            self.updateDataSource()
        }
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

    // MARK: - Update Photos
    
    private func updateDataSource() {
        store.fetchAllPhotos(ofType: photoType) {
            (photosResult) in
            
            switch photosResult {
            case let .success(photos):
                self.photoDataSource.photos = photos
            case .failure:
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto"?:
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                
                let photo = photoDataSource.photos[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        // Download the image data, which could take some time
        store.fetchImage(for: photo) { (imageResult) in
            
            // The index path for the photo might have changed between the
            // time the request started and finished, so find the most
            // recent index path
            
            guard let photoIndex = self.photoDataSource.photos.index(of: photo),
            case let .success(image) = imageResult
                else {
                    return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            
            // When the request finishes, only update the cell if it's still visible
            if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                cell.update(with: image)
            }
        }
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 4
        
        // calculate row spaces
        let rowSpaces = collectionViewSectionInsets.left + collectionViewSectionInsets.right + (itemsPerRow - 1) * (collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
        let availableWidth = collectionView.frame.width - rowSpaces
        let itemWidth = availableWidth / itemsPerRow
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionViewSectionInsets
    }
}
