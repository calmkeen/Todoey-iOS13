//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by calmkeen on 2022/02/23.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
             
        
             //for SWipteCellKit
        cell.delegate = self
             return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            print("Delete Cell")
            self.updateModel(at: indexPath)
           
//            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    //delegatte method for destructive
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        //style change
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }
    func updateModel(at indexPath: IndexPath) {
        
        //안뜨는 이유 category 에서 오버로딩을 통해 재정의된 기능이 사용되기 때문에 콜솔창에 뜨지 않는다
        
    }
}

