import Foundation
//isntead of Encodable and Decodable we can just write Codable, its new and contains the Encodable and Decodable Pritocoll
//we need this two protocolls because we want to use the item object to store our Data.

class Item : Encodable , Decodable{
    
    var title : String = ""
    var done : Bool = false
    
}
