

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    /*Gets called first. Immediatly after the app launched:*/
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        
        /*Prints where we store our Data.*/
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        let data = Data()
        data.name = "Julian"
        data.age = 20
        
        
        do{
            let realm = try Realm()
            try realm.write {
                    realm.add(data)
            }
        }
        catch{
            print("error initialising new realm \(error)")
        }
        
        
        return true
    }
    
    /*App is going to be terminated (can be user triggered or system triggered)*/
    func applicationWillTerminate(_ application: UIApplication) {

        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    /*lazy == only gets loaded up with a vaule when its needed:
      The NSPersistentContainer is where we are going to store all of our Data:
      the default PersistentContainer is a SQL like Database:*/
    lazy var persistentContainer: NSPersistentContainer = {

        /* now we create a constant called container that sets up this new persistent container with
           the name of our data model. (Data Model is DataModel.xcdatamodeld)
           these to names HAVE TO match*/
        let container = NSPersistentContainer(name: "DataModel")
        
        /*Here were going to load up this persistent Store:*/
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        
        /*if there weren't any errors we are going to return the container.
          then our persistentContainer contains this NSPersistentContainer Object.*/
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    /*We just need this method to call it in applicationWillTerminate to save everything that we did in our app bevor terminating.*/
    func saveContext () {
        /*essentially the context is an area where you can change and update your data so you can undo
          and redo until you're happy with your data.
          then you can save the data that's in your contacts (also called your temporary area) to the
          container which is for permanent storage.
          Simular to the staging area in github (diese zwischen area halt.)*/
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

