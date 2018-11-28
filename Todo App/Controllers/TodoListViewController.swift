//
//  ViewController.swift
//  Todo App
//
//  Created by Rajat Kumar on 22/11/18.
//  Copyright © 2018 Rajat Kumar. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: SwipeTableViewController {
    
//    var defaults = UserDefaults.standard
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
              load()
        }
    }
    
     //1. Create file path to the documents folder
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("listItem.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.rowHeight = 80.0
    }
    
    
    //MARK: - Delete Section, delete data from swipe
    
    override func update(at indexPath: IndexPath) {
        self.context.delete(self.itemArray[indexPath.row])
        self.itemArray.remove(at: indexPath.row)
    }
    
    //MARK: - TableView Data Source Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       // cell.textLabel?.text = itemArray[indexPath.row]
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Mark Ternary Operator
        //Value = condition?return value if True:return value if False
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK- TableViewDelegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
       // print(itemArray[indexPath.row])
        
        //to Update the data
       // itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        //to delete the data
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        //tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
      
    }
    
    //MARK:- BarButton
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Todo List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
          //  self.defaults.set(self.itemArray, forKey: "ToDOListArray")
            self.saveItems()
        }
            alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveItems(){
        
        do{
            try context.save()
        }
        catch{
            print("Error in loading the data \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK:- Function to fetch data from the plist database
    
    func load(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil){
       // let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, categoryPredicate])
    
//        request.predicate = compoundPredicate
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print("Error in Fetching the data \(error)")
        }
        tableView.reloadData()

    }
    

}

//MARK: - Extension for Search Bar View

extension TodoListViewController : UISearchBarDelegate{
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        load(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0){
            load()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }
            
            
        }
    }
    
}

