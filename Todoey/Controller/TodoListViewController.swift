//At this version if the code, the Userdefaults save method doesent work anymore. Because it is not made
//store large peaces of data. like instances of our items class. It's just for stuff like user settings.
//Because UserDefaults can only take stadard data and no custom data.
//The reason of this is: We store the data in a plist. A plist does only accept a view datatypes to store. These are all
//standard datatypes and no Datatypes like an object of a class we created (== custom datatypes).
//We use an encoder now. He simply takes our data changes it a little so that we can netherless store it in a plist.
//also whatch 247 bookmark.

import UIKit

class TodoListViewController: UITableViewController {

    //the only reason we didn't use an array of string is, we need to Store 2 pices of data.
    //the title of the thing we wanna do AND if its checked or not.
    var itemArray = [Item]()
    
    //this variable stores an refernce to an folder where we can store our data for this app:
    //(that is "the let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first"part )
    //in this folder we want to create a file with the name Itmes.plist (that is the rest):
    //the urls retuns an array and in this arry we want the first component:
    //with this line of code we merely create a path to the location where we want to safe our file. We did NOT creat a
    //file jet.
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        
        //we don't want to force unwrappe it in case that there is no Data in out Harddrive:
        //Xcode is clever enough to know that the thing we safed in the HD was an array.
        
        
        loadItems()
        
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
        
        //We don't need tableView.reloadData() because it's also within safeItems()
        //we need to safe that we clicket on our Cell to make a check mark:
        safeItems()
        
        //forces the table view to call its data source methods again:
            //tableView.reloadData()
        
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
            
            self.safeItems()
            }
        
        //Creating an alert:
        alert.addTextField { (alertTextField) in
            //placeholder is what's "written" in the textfield before you write something:
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    
    //MARK - Data Model Manipulatin Methods:
    
    func safeItems() {
        
        //an encoder (kodierer) is an Object that can Encode our Data so that we can store even
        //custom data in a for exampele  .plist file.:
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error encoding item array, \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    func loadItems() {
        //the try? turnes the code after it to an optinal. Now we use this known mehtod to safe unwrappe it:
        if  let data  = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                try itemArray = decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error decoding item array, \(error)")
            }
        }
        
        
    }
}

