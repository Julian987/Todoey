import UIKit
import RealmSwift

/*for comments see TodoListViewController.swift*/

class CategoryViewController: UITableViewController {

    /*Why not usig try catch ? see 263 bookmark.Short: we don't have to in this case tha's enough.*/
    let realm = try! Realm()
   
    
    /*when ever you quere objects from your database. The data comes back with the tipe of Result.
     Result is an auto updating container (container = for ex an array)*/
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    
    
    
    
    
    
    
    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey category", message: "hell yeah do it", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print(textField.text!)
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        /*Also Nil Coalescing Operator:*/
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories added yet."
        
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
