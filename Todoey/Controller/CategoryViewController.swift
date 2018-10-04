import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit


/*for comments see TodoListViewController.swift*/

//MARK: - Change
class CategoryViewController: /*SwipeTableViewController*/ UITableViewController {

    /*Why not usig try catch ? see 263 bookmark.Short: we don't have to in this case tha's enough.*/
    let realm = try! Realm()
   
    
    /*when ever you quere objects from your database. The data comes back with the tipe of Result.
     Result is an auto updating container (container = for ex an array)*/
    var categoryArray : Results<Category>?
    
//    var colourArray = ["#E84D3C" , "#FFCC02" , "#EFDDB3" , "#33495E" , "#2B2B2B" , "#3A7082" , "#1ABC9C" , "#EDF1F2" , "#335E40" , "#5E4433" , "#5E335E" , "#EF7079" , "#F47CC4" , "#B8C9F2" , "#5065A0"]
    
    var colourArray = [String]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        
        tableView.rowHeight = 80
        
        tableView.separatorStyle = .none 
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        navBar.barTintColor = UIColor(hexString: "FFED74")
        
        tableView.register(UINib(nibName: "CustomCategoryCell", bundle : nil), forCellReuseIdentifier: "CategoryCell")
        
        //If we didn't store something under the key colourArray then do nothing, but if we did then colour array should be that:
        if let colourArray1 = defaults.array(forKey: "colourArray") as! [String]? {
            colourArray = colourArray1
        }
        
        //MARK: - Change
        self.configureTableView()
        
        print("flatred: \(UIColor.flatRed.hexValue())")
        print("flatorange: \(UIColor.flatOrange.hexValue())")
        print("flatyellow: \(UIColor.flatYellow.hexValue())")
        print("flatsand: \(UIColor.flatSand.hexValue())")
        print("flatnavi blue: \(UIColor.flatNavyBlue.hexValue())")
        print("flatblack: \(UIColor.flatBlack.hexValue())")
        print("flatmagenta: \(UIColor.flatMagenta.hexValue())")
        print("flatteal: \(UIColor.flatTeal.hexValue())")
        print("flatsky blue: \(UIColor.flatSkyBlue.hexValue())")
        print("flatgreen: \(UIColor.flatGreen.hexValue())")
        print("flatmint: \(UIColor.flatMint.hexValue())")
        print("flatwhite: \(UIColor.flatWhite.hexValue())")
        print("flatgray: \(UIColor.flatGray.hexValue())")
        print("flatforest green: \(UIColor.flatForestGreen.hexValue())")
        print("flatpurple: \(UIColor.flatPurple.hexValue())")
        print("flatbrown: \(UIColor.flatBrown.hexValue())")
        print("flatplum: \(UIColor.flatPlum.hexValue())")
        print("flatwatermelon: \(UIColor.flatWatermelon.hexValue())")
        print("flatlime: \(UIColor.flatLime.hexValue())")
        print("flatpink: \(UIColor.flatPink.hexValue())")
        print("flatmaroon: \(UIColor.flatMaroon.hexValue())")
        print("flatcoffee: \(UIColor.flatCoffee.hexValue())")
        print("flatpowder blue: \(UIColor.flatPowderBlue.hexValue())")
        print("flatblue: \(UIColor.flatBlue.hexValue())")

        
//        updateNavBar(wirhHexCode: "FFED74")
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        updateNavBar(wirhHexCode: "FFED74")
    }
    
    
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
        

    }
    
    
    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Neue Kategorie", message: "Gib einen Namen für diese Kategorie ein.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Sichern", style: .default) { (action) in
            print(textField.text!)
            
            if let textInTextField = textField.text {
                
                if textInTextField != "" {
                    let newCategory = Category()
                    newCategory.name = textField.text!
                    newCategory.dateCreated = Date()
                    
                    /*Own modification:*/
                    //            newCategory.color = FlatGray().hexValue()
                    
                    print("colourArray.count : \(self.colourArray.count)")
                    
                    if self.colourArray.count >= 1{
                        let randomInt = Int.random(in: 0 ... self.colourArray.count - 1)
                        newCategory.color = UIColor(hexString: self.colourArray[randomInt])!.hexValue()
                        self.colourArray.remove(at: randomInt)
                        self.defaults.set(self.colourArray, forKey: "colourArray")
                    }
                        
                    else {
                        
                        self.colourArray = ["#E84D3C" , "#FFCC02" , "#EFDDB3" , "#33495E" , "#2B2B2B" , "#3A7082" , "#EDF1F2" , "#335E40" , "#5E4433" , "#5E335E" , "#EF7079" , "#F47CC4" , "#B8C9F2" , "#5065A0"]
                        let randomInt = Int.random(in: 0 ... self.colourArray.count - 1)
                        newCategory.color = UIColor(hexString: self.colourArray[randomInt])!.hexValue()
                        self.colourArray.remove(at: randomInt)
                        self.defaults.set(self.colourArray, forKey: "colourArray")
                    }
                    
                    
                    
//                    while (newCategory.color == "#E57D22") || (newCategory.color == "#9A58B5") || (newCategory.color == "#3498DB") || (newCategory.color == "#2ECC70") || (newCategory.color == "#95A4A5") || (newCategory.color == "#745EC4") || (newCategory.color == "#A6C63B") || (newCategory.color == "#773029") || (newCategory.color == "#A38570"){
//
//                        print("in while")
//
//                        newCategory.color = RandomFlatColorWithShade(.light).hexValue()
//
//
//                    }
                    self.configureTableView()
                    
                    self.save(category: newCategory)
                    
                }
                
            }
 
            /*We dont need to append the "array" anymore because it's auto updating its slef*/
            

        }
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .cancel) { (action) in
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Namen"
            textField = alertTextField
        }
        
        alert.addAction(cancelAction)
        
        alert.addAction(action)
        
        
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Change:
    
    func configureTableView() {

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80.0
        
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
        
        //MARK: - Change
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CustomCategoryCell
        
        cell.delegate = self
        
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "FFED74")
        cell.selectedBackgroundView = view
        

        
        
        
        
        /*Also Nil Coalescing Operator:*/
//        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "Noch keine Kategorien vorhanden."
        
        //MARK: - Change
        cell.cellTextLabel.text = categoryArray?[indexPath.row].name ?? "Noch keine Kategorien vorhanden."
        
        /*If the categoryArray was nil, then we are going to set a default collour for our Cell.*/
//        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].color ?? "1D9BF6")
        
        //MARK: - Change
        cell.cellBackround.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].color ?? "1D9BF6")
        
        if let category = categoryArray?[indexPath.row]{
            
            guard let categoryColour = UIColor(hexString: category.color) else {fatalError()}
            
//            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
            //MARK: - Change
            cell.cellTextLabel.textColor = ContrastColorOf(categoryColour, returnFlat: true)
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
        
        categoryArray = categoryArray?.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    
    }
    
    
    
    //MARK: - Delete Data From Swipe
    
    func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row]{
        
            do {
                try self.realm.write {
                    
                let endIndex = categoryForDeletion.items.endIndex
                    
                    print("endIndex is: \(endIndex)")
                    
                    if endIndex != 0 {
                        for index in 1...endIndex {
                            self.realm.delete(categoryForDeletion.items[endIndex - index])
                            print("endIndex is: \(categoryForDeletion.items.endIndex)")
                        }
                    }
                    
                    
                    
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
        
       
        //MARK: - Change:
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "goToItems" {
           
            let destinationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                /*ToDoListViewController has a property called selectedCategory. It's of type Category?. And if the property is not
                 nill the function loadItems() gets called. After that the items within that Category get load up in the
                 TableViewController.*/
                destinationVC.selectedCategory = categoryArray?[indexPath.row]
            }
            
        }

    }
}






//MARK:- Change
extension CategoryViewController: SwipeTableViewCellDelegate {
    
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
