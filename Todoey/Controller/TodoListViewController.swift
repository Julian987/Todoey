import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit
import AlertTransition
import LXStatusAlert

//MARK: - Change
class TodoListViewController: /*SwipeTableViewController*/ UITableViewController {
    
    /*the only reason we didn't use an array of string is, we need to Store 2 pices of data.
      the title of the thing we wanna do AND if its checked or not.*/
    var todoItems : Results<Item>?
    var OgTodoItemsForSearching : Results<Item>?
    let realm = try! Realm()
    let defaults = UserDefaults.standard
    var spackomodus : Bool? = nil
    var pictureArray = ["1" , "2" , "3" , "4" , "5" , "6" , "7" , "8" , "9" , "10" , "11" , "12"]
    var pictureTextArray = ["DONE" , "Not bad" , "Das ging schnell" , "Na endlich" , "NICE" , "Viel zu viel zu tun" , "YES" , "FINALLY" , "Erst mal n Caffe" , "Always busy" , "Jetzt ne Runde fernsehen" , "High five"]
    
    
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
        
        //MARK: - Change:
        tableView.register(UINib(nibName: "CustomTodoCell", bundle : nil), forCellReuseIdentifier: "TodoItemCell")
        
        
        //After View loaded up we know that spackomodus has a value
        spackomodus = defaults.bool(forKey: "SpackoModus")
        
        
        //MARK: - Change:
        self.configureTableView()
        
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
    
    
    /*Is called just before the View is going to be removed from the View Hierarchie / the navigation Stack: One important note. When we change the colour of the Navigation bar, we change the colour of every fucking Viewcontroller that is somehow connected to the
     Navigation controller. So when we go back we have to make shure to color the Navbar back to the color that it has before:
     */
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(wirhHexCode: "FFED74")
    }
    
    
    //MARK : - Nav Bar Setup Methods:
    
    func updateNavBar(wirhHexCode colourHexCode: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        
        navBar.barTintColor = navBarColour
        
        /*Making the collour of all navBar items be in contrast to the Backround like all the text:*/
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        if #available(iOS 11.0, *) {
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        } else {
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        }
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        searchBar.barTintColor = navBarColour
    }
    
    
    //MARK: - Tableview Datasource Methods:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("In ToDoList.. before cellForRow")
        
        /*This would cause an Bug based on the check mark of the cells see Video 243 bookmark:*/
        
        //MARK: - Change:
        /*let cell = super.tableView(tableView, cellForRowAt: indexPath)*/
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath) as! CustomTodoCell
        cell.delegate = self
        
        //MARK: - Change
        cell.indexPath = indexPath
        cell.tableView = tableView
        cell.todoListViewContoller = self
        
        print("In ToDoList.. after cellForRow")
        
        if let item = todoItems?[indexPath.row] {
            
            //MARK Change:
            /*cell.textLabel?.text = item.title*/
            
            cell.cellTextLabel.text = item.title
            
            
            /*CGFloat is short for CoreGraohicsFloat:*/
            
            
            //MARK: - Change
            //if let colour1 = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: (  CGFloat(indexPath.row) / CGFloat(todoItems!.count) )  ){ War der orginal code. und dann einfach die coulour varibale raushauen.
            
            if let colour1 = UIColor(hexString: selectedCategory!.color){
                
                var colour = UIColor()
                
                if (colour1.hexValue() == "#E84D3C") || (colour1.hexValue() == "#FFCC02") || (colour1.hexValue() == "#EFDDB3") || (colour1.hexValue() == "#EDF1F2") || (colour1.hexValue() == "#EF7079") || (colour1.hexValue() == "#F47CC4") || (colour1.hexValue() == "#B8C9F2"){
                    
                    colour = colour1.darken(byPercentage: (  CGFloat(indexPath.row) / CGFloat(todoItems!.count) )  )!
                
                }
                else {
                    colour = colour1.lighten(byPercentage: (  CGFloat(indexPath.row) / CGFloat(todoItems!.count) )  )!
                }

                //MARK: - Change:
                /*cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)*/
                
                cell.cellBackround.backgroundColor = colour
                cell.cellTextLabel.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            /*we are going to set the accesoryType property based on the value of item.done.
             is item.done true then we set it to .checkmark else we set it .none:*/
            
            //MARK: - Change:
            /*cell.accessoryType = item.done ? .checkmark : .none*/
            
            /*Just setting the Checkbox to checked or unchecked and dealing with some optionals:*/
            if let unchekedBoxImage = UIImage(named: "icons8-unchecked-checkbox-filled-50"){
                if let checkedBoxImage = UIImage(named: "icons8-checked-checkbox-filled-50"){
                    if item.done{
                        cell.chekFieldButton.setImage(checkedBoxImage, for: .normal)
                    }
                    else {
                        cell.chekFieldButton.setImage(unchekedBoxImage, for: .normal)
                    }
                }
            }
            
        
            
            
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
            
            if item.done {
                
                if spackomodus! {
                    
                    
                    if pictureArray.count >= 1 {
                        let randomInt = Int.random(in: 0 ... self.pictureArray.count - 1)
                        
                        let image = UIImage(named: pictureArray[randomInt])
                        
                        let statusAlert = LXStatusAlert(image: image!, title: pictureTextArray[randomInt], duration: 0.2)
                        
                        pictureArray.remove(at: randomInt)
                        
                        pictureTextArray.remove(at: randomInt)
                        
                        statusAlert.show()
                    }
                    
                    else{
                        pictureArray = ["1" , "2" , "3" , "4" , "5" , "6" , "7" , "8" , "9" , "10" , "11" , "12"]
                        
                        pictureTextArray = ["DONE" , "Not bad" , "Das ging schnell" , "Na endlich" , "NICE" , "Viel zu viel zu tun" , "YES" , "FINALLY" , "Erst mal n Caffe" , "Always busy" , "Jetzt ne Runde fernsehen" , "High five"]
                        
                        let randomInt = Int.random(in: 0 ... self.pictureArray.count - 1)
                        
                        let image = UIImage(named: pictureArray[randomInt])
                        
                        let statusAlert = LXStatusAlert(image: image!, title: pictureTextArray[randomInt], duration: 0.2)
                        
                        pictureArray.remove(at: randomInt)
                        
                        pictureTextArray.remove(at: randomInt)
                        
                        statusAlert.show()
                        
                        
                    }
                    
                }
                

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
        
        let alert = UIAlertController(title: "Neue Aufgabe", message: "Gib einen Namen für diese Aufgabe ein.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Sichern", style: .default) { (action) in
            /*what will happen once the user clicks the Add Item button on out UIAlert:*/
            print(textField.text!)
            
            if let currentCategory = self.selectedCategory{
                
                if let textInTextfield = textField.text{

                    if textInTextfield != ""{
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
                    else {
//                        /*Create an alert*/
//                        /*First, initialize your presented controller*/
//                        let alert = PopUpViewController()
//                        /* Second, initialize a subclass of AlertTransition, such as EasyTransition, configure your controller with it*/
//                        alert.at.transition = EasyTransition()
//                        /* Present your controller, Amazing!!*/
//                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            
            //MARK: - Debug:
            print("still works")
            
            self.configureTableView()
            
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .cancel) { (action) in
            /*We just want to cancel so we don't need to write any code*/
        }
        
        /*Creating an alert:*/
        alert.addTextField { (alertTextField) in
            /*placeholder is what's "written" in the textfield before you write something:*/
            alertTextField.placeholder = "Name"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    func configureTableView() {
        
        //MARK: - I think the i can clean the if statement:
        if let items = todoItems {
            if items.isEmpty{
                tableView.rowHeight = 80.0
            }
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80.0

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
    
    
    
    
    //MARK: - Delete Data From Swipe:
    
    //MARK: - Change:
    /*override*/ func updateModel(at indexPath: IndexPath) {
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

    /*Important to Know here: You write something in your searchbar. Then you click the searchBarSearchButton. After that this function
     gets triggered. Then this function surches in your DATAMODEL so our List of Items. And the it displays the new Data in the Cells
     of our TableView. It doesen't search for the content in your Cells that you display on screen it searches in the DATABASE:*/
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchBarText = searchBar.text {
            
            if searchBarText != ""{
                print("search Button clicked")
                todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
                //        makeKeyboardDissapear()
                tableView.reloadData()
            }
            
            else {
                makeKeyboardDissapear()
            }
        }
        
        
        
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
        
//        else {
//            //MARK: - Search test
//            todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
//            tableView.reloadData()
//        }
    }
    
    
    @objc func makeKeyboardDissapear(){
        DispatchQueue.main.async{
            /*Makes keyboard and the curser in the searchbar dissapear: see also 258 bookmark*/
            self.searchBar.resignFirstResponder()
        }
    }


}




//MARK:- Change
extension TodoListViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Löschen") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
}


