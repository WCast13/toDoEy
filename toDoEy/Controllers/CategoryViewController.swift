//
//  CategoryViewController.swift
//  toDoEy
//
//  Created by WilliamCastellano on 1/4/18.
//  Copyright © 2018 WCTech. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
  
  let realm = try! Realm()
  
  var categoryArray: Results<Category>?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadCategories()
  }
  
  //MARK: - TableView Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryArray?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
    cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
    
    return cell
  }
  
  
  //MARK: - Data Manipulation Functions- Save/Load Data
  
  func saveCategories(category: Category) {
    do {
      try realm.write {
        realm.add(category)
      }
    } catch {
      print("Error saving context: \(error)")
    }
    
    tableView.reloadData()
  }
  
  func loadCategories() {
    
    categoryArray = realm.objects(Category.self)
    
    tableView.reloadData()
  }
  
  
  //MARK: - Add New Categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      
      let newCategory = Category()
      newCategory.name = textField.text!
      
      self.saveCategories(category: newCategory)
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Add New Category"
      textField = alertTextField
    }
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  
  
  //MARK: - TableView Delagate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categoryArray?[indexPath.row]
    }
  }
}
