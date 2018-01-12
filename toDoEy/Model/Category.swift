//
//  Category.swift
//  toDoEy
//
//  Created by WilliamCastellano on 1/9/18.
//  Copyright © 2018 WCTech. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var name = ""
  let items = List<Item>()
}
