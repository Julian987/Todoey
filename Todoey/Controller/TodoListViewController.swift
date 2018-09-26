import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    /*the only reason we didn't use an array of string is, we need to Store 2 pices of data.
      the title of the thing we wanna do AND if its checked or not.*/
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedCategory : Category? {
        /*If the property selectedCategory is set, then call loadItems:*/
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*We did also this class as the delegate of searchbar but we did it in Main.Storyboard. See also Video 257 bookmark.*/
        
        print(FileManager.default.urls(for: .documentDirectory,in: .userDomainMask))
        
        tableView.rowHeight = 80
        
        tableView.separatorStyle = .none
        
        if let colourHex = selectedCategory?.color {
            navigationController?.navigationBar.barTintColor = UIColor(hexString: colourHex)
            /*Own modification: */
            self.tableView.backgroundColor = UIColor(hexString: colourHex)
        }
        
    }

    /*Get's called later than viewDidLoad so that's the right point for us to set up the collor for our TableView. Why ?
     Watch 275 bookmark. Hint: It's becaus of "navigationcontroller?. ..." . Just because the View of our tableView did show up
     does not mean that our TodoListViewController Class object is already on the stack of the NavigationViewController. I mean that
     one from the Main.storyboard. This function get's called after view DidLoad so we do our UI Stuff here. This function get's
     calles just the moment before the User sees the View on the Screen:*/
    override func viewWillAppear(_ animated: Bool) {
        
        
        title  = selectedCategory!.name
        
        /*Why using guard let instead of if let ? Watch 275 bookmark.*/
        guard let colourHex = selectedCategory?.color else{ fatalError() }
            
        updateNavBar(wirhHexCode: colourHex)
        
        
    }
    
    
    /*Is called just before the View is going to be removed from the View Hierarchie / the navigation Stack:*/
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(wirhHexCode: "1D9BF6")
    }
    
    
    //MARK : - Nav Bar Setup Methods:
    
    func updateNavBar(wirhHexCode colourHexCode: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColour
        
        /*Making the collour of all navBar items be in contrast to the Backround like all the text:*/
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
    }
    
    
    //MARK: - Tableview Datasource Methods:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("In ToDoList.. before cellForRow")
        
        /*This would cause an Bug based on the check mark of the cells see Video 243 bookmark:*/
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        print("In ToDoList.. after cellForRow")
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            /*CGFloat is short for CoreGraohicsFloat:*/
            if let colour = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: (  CGFloat(indexPath.row) / CGFloat(todoItems!.count) )  ){

                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            /*we are going to set the accesoryType property based on the value of item.done.
             is item.done true then we set it to .checkmark else we set it .none:*/
            cell.accessoryType = item.done ? .checkmark : .none
        
        }
        
        
        else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        return cell
    }
    
    
    
    
    
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*To check or uncheck the cells:*/
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }
            catch{
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
 
    }
    
    
    
    // MARK: - Add new Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("worked")
        /*the local variable we need to get access to the alertTextfield.text also outside of the
           alert.addTextField function.*/
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey item", message: "hell yeah do it", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            /*what will happen once the user clicks the Add Item button on out UIAlert:*/
            print(textField.text!)

            if let currentCategory = self.selectedCategory{
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    print("Error saving new Item, \(error)")
                }
            }
            
            
            //MARK: - Debug:
            print("still works")
            
            
            
            self.tableView.reloadData()
        }
        
        /*Creating an alert:*/
        alert.addTextField { (alertTextField) in
            /*placeholder is what's "written" in the textfield before you write something:*/
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    
    //MARK: - Data Model Manipulatin Methods:
    
    func save(){
    
    }
    
    /*here Xcode isn't clever enough to know the datatype so we have to explicitly define it:
     Here we provide a default Value for request if we simply call loadItems():*/
    func loadItems() {

    todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }
    
    
    
    
    //Mark: - Delete Data From Swipe:
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row]{
            
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }
            catch {
                print("Error deletig item, \(error)")
            }
        }
        tableView.reloadData()
    }
}


// MARK: - Serach bar methods:
/*Just a way to organise your big controller file better.
 In this Part of the file we are going to put all searchbar functions.*/

extension TodoListViewController: UISearchBarDelegate {


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search Button clicked")
        todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

   
    /*Whenever there are any Changes in Searchbar.text this function gets called. So also when the little x button gets pressed:*/
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /*If the Text in Searchbar gets Changed and contains no character:*/
        
        if searchBar.text?.count == 0 {
            loadItems()

            /*The DispathQueue is the Object that decides on which thread our code gets executet. Because we want to change
               something in the user interface, we want it to be done on the main thread (the fastest one). That's what we are saying
               here.See also 258 bookmark. We need to specify it because we might not be in main thread right now because we said
               loadItems() and that happens in the backroud (== not the main thread). So with DispatchQueue.main.async{} we say:
               Doesen't matter how long it takes to load the data, you go jump to the main thread right now and change the user
               interface.*/
            DispatchQueue.main.async{
                /*Makes keyboard and the curser in the searchbar dissapear: see also 258 bookmark*/
                searchBar.resignFirstResponder()
            }

        }
    }


}
