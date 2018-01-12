//
//  Item.swift
//  toDoEy
//
//  Created by WilliamCastellano on 1/9/18.
//  Copyright © 2018 WCTech. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
  @objc dynamic var title = ""
  @objc dynamic var done = false
  @objc dynamic var dateCreated: Date?
  var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
