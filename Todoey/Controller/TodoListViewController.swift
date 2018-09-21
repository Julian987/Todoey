/*At this version if the code, the Userdefaults save method doesent work anymore. Because it is not made
  store large peaces of data. like instances of our items class. It's just for stuff like user settings.
  Because UserDefaults can only take stadard data and no custom data.
  The reason of this is: We store the data in a plist. A plist does only accept a view datatypes to store. These are all
  standard datatypes and no Datatypes like an object of a class we created (== custom datatypes).
  We use an encoder now. He simply takes our data changes it a little so that we can netherless store it in a plist.
  also whatch 247 bookmark.*/

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    /*the only reason we didn't use an array of string is, we need to Store 2 pices of data.
      the title of the thing we wanna do AND if its checked or not.*/
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        /*If the property selectedCategory is set, then call loadItems:*/
        didSet{
            loadItems()
        }
    }
    
    /*this variable stores an refernce to an folder where we can store our data for this app:
      (that is "the let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first"part )
      in this folder we want to create a file with the name Itmes.plist (that is the rest):
      the urls retuns an array and in this arry we want the first component:
      with this line of code we merely create a path to the location where we want to safe our file. We did NOT creat a
      file jet.*/
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*We did also this class as the delegate of searchbar but we did it in Main.Storyboard. See also Video 257 bookmark.*/
        
        print(FileManager.default.urls(for: .documentDirectory,in: .userDomainMask))
    
    }

    
    
    
    
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*This would cause an Bug based on the check mark of the cells see Video 243 bookmark:*/
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        /*we are going to set the accesoryType property based on the value of item.done.
          is item.done true then we set it to .checkmark else we set it .none:*/
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    
    
    
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            //print(itemArray[indexPath.row])
        
        /*We swich true to false and false to true:*/
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
       
        /*deletes our item objet itemArray[indexPath.row] and with calling save finaly removes it form
           our databse We have to call this before itemArray.delete because otherweise this code will
           throw an index out of range error or behaving strange:*/
          //context.delete(itemArray[indexPath.row])
        
        /*deletes the wahtever is in the array at index indexPath.row:*/
        //itemArray.remove(at: indexPath.row)
        
        
        

        
        
        /*We don't need tableView.reloadData() because it's also within safeItems()
           we need to safe that we clicket on our Cell to make a check mark:*/
        safeItems()
        
        /*forces the table view to call its data source methods again:*/
            //tableView.reloadData()
    
        /*when you click on a cell it gets gray and usually stays grey. With this method it gets gray the moment you click on it
          and after that the grey backround dissapears:*/
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
            
            /*for setting up the new Item we need a context object:
               first read the text below.
               with UIApplication.shared returns an App instance. While the app is running this app isntance will correspond to
               to our live application Object. This Instance we created has an property called delegate. This is the delegate of
               our app. Now we can downcast it to Object of our AppDelegate class. Now we have our AppDelegate Object
               (it's "(UIApplication.shared.delegate as! AppDelegate)" ) and we can go to the property persistentContainer
               and persistentContainer has the property viewContext. And THATS what we want:*/
            
            /*we made the varibale context a global variable so look at the top of this file to actually see it.*/
                //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            
            /*Item is now of type NSManagedObject because we created our class with the help of Xcode and the Core Data Modell.
               to create a new Item we firtst need an Object of type NSManagedObjectContext. We have to specify the context where
               this item is going to exist. But what context is it going to be ?
               It's going to be the viewContext of our Persistent Container in our AppDelegate Class. (the one with lazy)
               So now we need access to that content. That means we need an Instance of our AppDelegate Class to get access to the
               PersistentConatiner property.
               Now read on above:*/
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.safeItems()
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
    
    func safeItems() {
        
        do {
            try context.save()
        }
        catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    /*here Xcode isn't clever enough to know the datatype so we have to explicitly define it:
     Here we provide a default Value for request if we simply call loadItems():*/
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest() , predicate : NSPredicate? = nil) {
        
        /*It's always filterd by the parentCategory and ontional also by something else:*/
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate , additionalPredicate])
        }
        
        else {
            request.predicate = categoryPredicate
        }
        
    
        
        do {
            itemArray = try context.fetch(request)
        }
        catch{
            print("Error fetching data from comtext \(error)")
        }
        tableView.reloadData()
    }
}


// MARK: - Serach bar methods:
/*Just a way to organise your big controller file better.
 In this Part of the file we are going to put all searchbar functions.*/

extension TodoListViewController: UISearchBarDelegate {
    
    /*What we do in this function:
      We create a request to the Database and say we want to fatch Data. Then we specify the request with the help of our
      Predicate. We only want the Data where the titel contains what we just typed in the searchbar, case and decretic
      unsesitive. Then we say we want the Data sourtet ascending by the title.*/
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //print(searchBar.text!)
        
        /*After the function gets called the Compiler makes the Parameters to "title CONTAINS whaterver is in searchBar.text!"
         It's like in C. With [cd] we turn of case sensitiv and dicretic sensitiv (bsp here i = î):*/
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        /*with a predicat we specify how we specify how we wnat to query( = abfragen) our data*/
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request , predicate: predicate)
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


