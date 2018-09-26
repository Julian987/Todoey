import Foundation
import RealmSwift

/*Why Objects ? obtion click Object*/
class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    /*Each Category object has an array of pointers to item objects. That's for creating the Relationship between Item
      and Category:*/
    let items = List<Item>()
    
}
