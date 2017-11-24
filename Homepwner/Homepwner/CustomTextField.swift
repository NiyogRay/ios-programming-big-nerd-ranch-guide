import UIKit

class CustomTextField: UITextField {

    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.red.cgColor

        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        
        layer.borderWidth = 0.1
        layer.borderColor = UIColor.lightGray.cgColor
        
        return true
    }

}
