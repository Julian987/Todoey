

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    /*Gets called first. Immediatly after the app launched:*/
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        /*Prints where we store our Data.*/
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
            let realm = try Realm()
        }
        catch{
            print("error initialising new realm \(error)")
        }
        return true
    }


}


