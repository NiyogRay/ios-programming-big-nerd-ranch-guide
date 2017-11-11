import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    // UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount: Int
        switch section {
        case 0:
            rowCount = itemStore.itemsLessThanEqual50.count
        case 1:
            rowCount = itemStore.itemsGreaterThan50.count
        default:
            rowCount = 0
        }
        return rowCount
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title: String?
        switch section {
        case 0:
            title = "Items less or equal to $50"
        case 1:
            title = "Items greater than $50"
        default:
            title = nil
        }
        return title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        
        let section = indexPath.section
        let row = indexPath.row
        let item: Item
        switch section {
        case 0:
            item = itemStore.itemsLessThanEqual50[row]
        case 1:
            item = itemStore.itemsGreaterThan50[row]
        default:
            item = Item()
        }
        
        // contents
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        return cell
    }
}
