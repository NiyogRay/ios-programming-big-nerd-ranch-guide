import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Also available in Attributes Inspector > Dynamic Type > Automatically Adjusts Font
//        nameLabel.adjustsFontForContentSizeCategory = true
//        serialNumberLabel.adjustsFontForContentSizeCategory = true
//        valueLabel.adjustsFontForContentSizeCategory = true
    }
}
