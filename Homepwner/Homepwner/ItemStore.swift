import UIKit

class ItemStore {
    
    var allItems = [Item]()
    var itemsLessThanEqual50 = [Item]()
    var itemsGreaterThan50 = [Item]()
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        
        return newItem
    }
    
    init() {
        for _ in 0..<5 {
            createItem()
        }
        
        itemsLessThanEqual50 = allItems.filter { $0.valueInDollars <= 50 }
        itemsGreaterThan50 = allItems.filter { $0.valueInDollars > 50 }
    }
}
