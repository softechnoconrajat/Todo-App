//
//  SwipeTableViewController.swift
//  Todo App
//
//  Created by Rajat Kumar on 28/11/18.
//  Copyright © 2018 Rajat Kumar. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                //to delete the data
                
                self.update(at: indexPath)
//                self.context.delete(self.categories[indexPath.row])
//                self.categories.remove(at: indexPath.row)
                
            }
            
            // customize the action appearance
            deleteAction.image = UIImage(named: "Trash Icon")
            return [deleteAction]
        }
        
        
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
            //options.transitionStyle = .border
        return options
        }
    
    func update(at indexPath: IndexPath){
        
    }
}
