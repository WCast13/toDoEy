//
//  CategoryViewController.swift
//  toDoEy
//
//  Created by WilliamCastellano on 1/4/18.
//  Copyright © 2018 WCTech. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

  var catagoryArray = [Catagory]()
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    override func viewDidLoad() {
        super.viewDidLoad()
      loadCatagories()
    }
  
  //MARK: - TableView Datasource Methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return catagoryArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCell", for: indexPath)
    let catagoryItem = catagoryArray[indexPath.row]
    
    cell.textLabel?.text = catagoryItem.name
    
    return cell
  }
  
  
  //MARK: - Data Manipulation Functions- Save/Load Data
  
  func saveCatagories() {
    do {
      try context.save()
    } catch {
      print("Error saving context: \(error)")
    }
    
    tableView.reloadData()
  }
  
  func loadCatagories(with request: NSFetchRequest<Catagory> = Catagory.fetchRequest()) {
    
    do {
      catagoryArray = try context.fetch(request)
    } catch {
      print("Error fetching data from context: \(error)")
    }
    
    tableView.reloadData()
  }
  

  //MARK: - Add New Catagories

  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Catagory", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Catagory", style: .default) { (action) in
      
      let newCatagory = Catagory(context: self.context)
      newCatagory.name = textField.text!
      
      self.catagoryArray.append(newCatagory)
      
      self.saveCatagories()
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Add New Catagory"
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
      destinationVC.selectedCatagory = catagoryArray[indexPath.row]
    }
  }
}
