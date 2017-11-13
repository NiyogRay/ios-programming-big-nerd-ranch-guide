import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel: ValueLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Also available in Attributes Inspector > Dynamic Type > Automatically Adjusts Font
//        nameLabel.adjustsFontForContentSizeCategory = true
//        serialNumberLabel.adjustsFontForContentSizeCategory = true
//        valueLabel.adjustsFontForContentSizeCategory = true
    }
}

class ValueLabel: UILabel {
    
    override var text: String? {
        didSet {
            if let validText = text {
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                
                if let value = formatter.number(from: validText) {
                    let amount = value.intValue
                    if amount >= 50 {
                        textColor = UIColor.red
                    }
                    else if amount < 50 {
                        textColor = UIColor.green
                    }
                }
                else {
                    textColor = UIColor.darkText
                }
            }
        }
    }
}
