//
//  CategoryViewController.swift
//  Todo App
//
//  Created by Rajat Kumar on 26/11/18.
//  Copyright © 2018 Rajat Kumar. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
     var categories = [Category]()
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()

       
    }

   
    //MARK: - Add new Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Category(context: self.context )
            newItem.name = textField.text!

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
    
    // Save  Items
    
    func saveItems(){
        
        do{
            try context.save()
        }
        catch{
            print("Error in loading the data \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Table view Data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = categories[indexPath.row]
        cell.textLabel?.text = item.name
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
    
    


