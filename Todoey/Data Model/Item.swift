import Foundation
import RealmSwift


class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    
    /*It's simply defining the inverse Relationship of Items to Category.
     LinkingObjects(fromType: Object.Type, property: String) is the definition. It's not enough to write Category.
     We have to write Category.self to make it a type. Items because the reverse relationship variable in Category
     is called items.*/
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
}
