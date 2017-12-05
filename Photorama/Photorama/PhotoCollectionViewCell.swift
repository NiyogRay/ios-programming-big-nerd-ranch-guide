import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    // MARK: - Set
    
    func update(with image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        }
        else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    // called when the cell is first created
    override func awakeFromNib() {
        super.awakeFromNib()
        
        update(with: nil)
    }
    
    // called when the cell is getting reused
    override func prepareForReuse() {
        super.prepareForReuse()
        
        update(with: nil)
    }
}
