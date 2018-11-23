//
//  ViewController.swift
//  Todo App
//
//  Created by Rajat Kumar on 22/11/18.
//  Copyright © 2018 Rajat Kumar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    
//    var defaults = UserDefaults.standard
    
    var itemArray = [Item]()
    
     //1. Create file path to the documents folder
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("listItem.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       load()
        
        
    }
    
    //MARK-TableView Data Source Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       // cell.textLabel?.text = itemArray[indexPath.row]
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Mark Ternary Operator
        //Value = condition?return value if True:return value if False
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
    //Mark- TableViewDelegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
       // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        //tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
      
    }
    
    //Mark- BarButton
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todo List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let itemCreated = Item()
            itemCreated.title = textField.text!
            
            self.itemArray.append(itemCreated)
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
        
        //To save the data at file Location
        //1. Encode the data using the propertyListEncoder class instance
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            //2. Write the file at the given path mentioned above
            try data.write(to: dataFilePath!)
            
        }
        catch{
            print("Error in loading the data \(error)")
        }
        
        tableView.reloadData()
    }
    
    //Mark:- Function to fetch data from the plist database
    
    func load(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("Error in loading the data \(error)")
            }
            
            
            
        }
        
    }
    

}

