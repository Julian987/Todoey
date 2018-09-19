import UIKit

class TodoListViewController: UITableViewController {

    //the only reason we didn't use an array of string is, we need to Store 2 pices of data.
    //the title of the thing we wanna do AND if its checked or not.
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //we don't want to force unwrappe it in case that there is no Data in out Harddrive:
        //Xcode is clever enough to know that the thing we safed in the HD was an array.
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
        
        let newItem = Item()
        newItem.title  = "Finde Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title  = "Buy Eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title  = "Destroy Demogorgon"
        itemArray.append(newItem3)
        
        
    }

    
    
    
    
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //This would cause an Bug based on the check mark of the cells see Video 243 bookmark:
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //we are going to set the accesoryType property based on the value of item.done.
        //is item.done true then we set it to .checkmark else we set it .none:
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    
    
    
    
    
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            //print(itemArray[indexPath.row])
        
        //We swich true to false and false to true:
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
       
        //forces the table view to call its data source methods again:
        tableView.reloadData()
        
        //if there is no check mark then insert one, if there is allready one then delete it:
        
        
        //when you click on a cell it gets gray and usually stays grey. With this method it gets gray the moment you click on it
        //and after that the grey backround dissapears:
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    
    
    // MARK - Add new Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //the local variable we need to get access to the alertTextfield.text also outside of the
        //alert.addTextField function.
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey item", message: "hell yeah do it", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on out UIAlert:
            print(textField.text!)
            
            
            let newItem = Item()
            newItem.title = textField.text!
            
            
            self.itemArray.append(newItem)
            
            
            //We can find this array now under the key "TodoListArray"
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
            
            }
        
        
        alert.addTextField { (alertTextField) in
            //placeholder is what's "written" in the textfield before you write something:
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
}

