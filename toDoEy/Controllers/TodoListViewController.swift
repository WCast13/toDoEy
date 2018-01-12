//
//  ViewController.swift
//  toDoEy
//
//  Created by WilliamCastellano on 12/29/17.
//  Copyright © 2017 WCTech. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {
  
  var toDoItems : Results<Item>?
  let realm = try! Realm()
  
  var selectedCategory: Category? {
    didSet {
      loadItems()
    }
  }
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    
  }
  
  //MARK: - TableView DataSource Method
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return toDoItems?.count ?? 1
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
    if let item = toDoItems?[indexPath.row] {
      cell.textLabel?.text = item.title
      
      // Ternary Operator ==>
      // value = condition ? valueIfTrue : valueIfFalse
      
      cell.accessoryType = item.done ? .checkmark : .none
    } else {
      cell.textLabel?.text = "No Items Added"
    }
    
    return cell
  }
  
  //MARK: - TableView Delagate Method
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let item = toDoItems?[indexPath.row] {
      do {
        try realm.write {
//          realm.delete(item)
          item.done = !item.done
        }
      } catch {
        print("Error saving done status: \(error)")
      }
    }
    
    tableView.reloadData()
    
    
//    toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done          // UPDATE DONE PROPERTY CORE DATA
//    itemArray[indexPath.row].setValue("Completed", forKey: "title")   // UPDATE TITLE PROPERTY CORE DATA
//
//
//    context.delete(itemArray[indexPath.row])    // DELETE ROW - STEP 1 CORE DATA
//    itemArray.remove(at: indexPath.row)         // DELETE ROW - STEP 2 CORE DATA
//
//
//    saveItems()
    
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if let newItem = toDoItems?[indexPath.row] {
      if editingStyle == .delete {
        do {
          try realm.write {
            realm.delete(newItem)
          }
          tableView.deleteRows(at: [indexPath], with: .fade)
        } catch {
          // Print error
        }
      }
    }
  }
  
  //MARK: - Add New Items
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // What will happen once the user presses the add item buttun
      
      if let currentCategory = self.selectedCategory {
        do {
          try self.realm.write {
            let newItem = Item()
            newItem.title = textField.text!
            newItem.dateCreated = Date()
            currentCategory.items.append(newItem)
          }
        } catch {
          print("Error saving new items: \(error)")
        }
      }
      
      self.tableView.reloadData()
      
      
      // CREATE NEW ITEMS WITH CORE DATA
      //      let newItem = Item(context: self.context)
      //      newItem.title = textField.text!
      //      newItem.done = false
      //      newItem.parentCategory = self.selectedCategory
      
      //      self.itemArray.append(newItem)
      
//      self.saveItems()
    }
    
    
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create New Item"
      textField = alertTextField
    }
    
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
    
  }
  
  //MARK: - Model manipulation Methods
  
  func saveItems() {
    
    
    do {
      try context.save()
    } catch {
      print("Error saving context: \(error)")
    }
    
    self.tableView.reloadData()
  }
  
  func loadItems() {
    
    toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    
    tableView.reloadData()
  }
}

//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    
    tableView.reloadData()
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    if searchBar.text?.count == 0 {
      loadItems()
      
      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
    }
  }
}


/*
 
 Sort by date created
 add date created property in item
 saved when created a new item
 
 
 */



