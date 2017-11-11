import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    
    @IBAction func addNewItem(_ sender: UIButton) {
        // Create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        // Figure out where that item is in the array
        if let index = itemStore.allItems.index(of: newItem) {
            let newIndexPath = IndexPath(row: index, section: 0)
            
            // Insert this new row into the table
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        // If currently in editing mode...
        if isEditing {
            // ... turn off editing mode
            
            // Change text of button to inform user of state
            sender.setTitle("Edit", for: .normal)
            
            // Turn off editing mode
            setEditing(false, animated: true)
        }
        else {
            // ... turn on editing mode
            
            // Change text of button to inform user of state
            sender.setTitle("Done", for: .normal)
            
            // Turn on editing mode
            setEditing(true, animated: true)
        }
    }
    
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
            rowCount = itemStore.allItems.count
        case 1:
            rowCount = 1
        default:
            rowCount = 0
        }
        return rowCount
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowHeight: CGFloat
        switch indexPath.section {
        case 0:
            rowHeight = 60
        default:
            rowHeight = 44
        }
        return rowHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a new or recycled cell
        let cell: UITableViewCell
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        
        let section = indexPath.section
        let row = indexPath.row
        let item: Item?
        
        switch section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
            item = itemStore.allItems[row]
            cell.textLabel?.text = item!.name
            cell.detailTextLabel?.text = "$\(item!.valueInDollars)"
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
            item = nil
            cell.textLabel?.text = "No more items!"
            cell.detailTextLabel?.text = nil
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
            item = nil
            cell.textLabel?.text = nil
            cell.detailTextLabel?.text = nil
        }
        
        return cell
    }
}
