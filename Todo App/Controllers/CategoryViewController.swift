//
//  CategoryViewController.swift
//  Todo App
//
//  Created by Rajat Kumar on 26/11/18.
//  Copyright © 2018 Rajat Kumar. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
     var categories = [Category]()
    

     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none

       
    }

   
    //MARK: - Add new Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Category(context: self.context )
            newItem.name = textField.text!
            newItem.color = UIColor.randomFlat.hexValue()

           self.categories.append(newItem)
            self.saveItems()
            
        }
     
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: -Save  Items
    
    func saveItems(){
        
        do{
            try context.save()
        }
        catch{
            print("Error in loading the data \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Delete Section, delete data from swipe
    
    override func update(at indexPath: IndexPath) {
        self.context.delete(self.categories[indexPath.row])
        self.categories.remove(at: indexPath.row)
    }
    
    
    //MARK: - Table view Data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
//       let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
//        cell.delegate = self
//        
         let item = categories[indexPath.row]
         cell.textLabel?.text = item.name
        
       
        
        
        cell.backgroundColor = UIColor(hexString: categories[indexPath.row].color ?? "1D9B6F")
        
        
         return cell
    }
    
    
    //MARK: - Table view Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
        
    }
    
    

    //MARK: - Data Manipulation Methods
    
    func load(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        // let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
            categories = try context.fetch(request)
        }
        catch{
            print("Error in Fetching the data \(error)")
        }
        tableView.reloadData()
    }
}


