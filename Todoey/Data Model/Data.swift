//
//  Data.swift
//  Todoey
//
//  Created by Julian Gurdan on 21.09.18.
//  Copyright © 2018 Julian Gurdan. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    
    /*Why dynamic and @objc ? See video 262 bookmark. Hint: it's for dynamic dispatch(Dynamische Bindung).
      If you change for example the name property while the app is running this allows realm to dynamicly update
      those changes in the database. Dynamic change comes from the Objective-C APIs and that's why we need a @objc*/
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}
