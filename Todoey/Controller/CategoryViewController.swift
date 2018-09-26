import UIKit
import RealmSwift
import ChameleonFramework

/*for comments see TodoListViewController.swift*/

class CategoryViewController: SwipeTableViewController {

    /*Why not usig try catch ? see 263 bookmark.Short: we don't have to in this case tha's enough.*/
    let realm = try! Realm()
   
    
    /*when ever you quere objects from your database. The data comes back with the tipe of Result.
     Result is an auto updating container (container = for ex an array)*/
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        
        tableView.rowHeight = 80
        
        tableView.separatorStyle = .none

    }
    
    
    
    
    
    
    
    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey category", message: "hell yeah do it", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print(textField.text!)
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()

            /*Own modification:*/
//            newCategory.color = RandomFlatColorWithShade(.light).hexValue()
            
            /*We dont need to append the "array" anymore because it's auto updating its slef*/
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: - TableView Datasource Methods
    
    /*With the Nil Coalescing Operator we achieved that if the categoryArry is nil then the first function returns 1 and
     the second reuturns "No Categories added yet" That means our TableView has exactly 1 Cell with "No Catogories added yet":*/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*Nil Coalescing Operator: Only get the count of categoryArray if its not nil if it's nil then return 1*/
        return categoryArray?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*All we do right now is creating the cell we use for our Table View in our Superclass SwipeTableViewController.*/
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        /*Also Nil Coalescing Operator:*/
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories added yet."
        
        /*If the categoryArray was nil, then we are going to set a default collour for our Cell.*/
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].color ?? "1D9BF6")
        
        if let category = categoryArray?[indexPath.row]{
            
            guard let categoryColour = UIColor(hexString: category.color) else {fatalError()}
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        return cell
    }
    
    
    
    
    
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    

    func loadCategories() {
    
        /*Pull out all of the object in our Realm, that are Categories:*/
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    
    }
    
    
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row]{
        
            do {
                try self.realm.write {
                self.realm.delete(categoryForDeletion)
                }
            }
        catch {
                print("Error deletig category, \(error)")
                }
        }
        tableView.reloadData()
    }
    
    
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            /*ToDoListViewController has a property called selectedCategory. It's of type Category?. And if the property is not
              nill the function loadItems() gets called. After that the items within that Category get load up in the
              TableViewController.*/
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
}

