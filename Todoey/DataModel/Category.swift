//
//  Category.swift
//  Todoey
//
//  Created by calmkeen on 2022/02/21.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift


class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    
    let items = List<Item>()
    let array = Array<Int>()
}
