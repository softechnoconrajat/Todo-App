//
//  ViewController.swift
//  Todo App
//
//  Created by Rajat Kumar on 22/11/18.
//  Copyright © 2018 Rajat Kumar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController{
    
    var defaults = UserDefaults.standard
    
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let items = Item()
        items.title = "Find Mike"
        itemArray.append(items)
        
        let items2 = Item()
        items2.title = "Find Grey"
        itemArray.append(items2)
        
        let items3 = Item()
        items3.title = "Find Ponting"
        itemArray.append(items3)
        
        if let item =  UserDefaults.standard.array(forKey: "ToDOListArray") as? [Item]{
            itemArray = item
        
       }
        
        
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
        

        tableView.reloadData()
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
            self.defaults.set(self.itemArray, forKey: "ToDOListArray")
            self.tableView.reloadData()
        }
        
            alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    

}

