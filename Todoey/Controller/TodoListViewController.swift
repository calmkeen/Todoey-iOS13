//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework


class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedCategory : Category? {
        didSet{
            loadItem()
        }
    }
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
        
        override func viewWillAppear(_ animated: Bool) {
            if let colourHex = selectedCategory?.colour{
                
                title = selectedCategory?.name
                
                guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
                
                if let navBarColour = UIColor(hexString: colourHex){
                    
                    navBar.barTintColor = navBarColour
                    
                    navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                    
                    navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
                    
                    searchBar.barTintColor = navBarColour
                }
                
                
            }
            
        }
        //MARK: - tableview datasource method
        
        //        if let items = defaults.array( forKey: "TodoListArray") as? [Item]{
        //            arrary = items
        //        }
        // Do any additional setup after loading the vie
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
                                                
            
            
            
            cell.accessoryType = item.done ? .checkmark : .none
            //Ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
        } else {
            cell.textLabel?.text  = "no items added"
        }
        return cell
    }
    
    
    //      return cell
    
    
    // 업데이트에 사용하는게 좋다. didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //print(arrary[indexPath.row])
    //삭제 기능 순서 중요
    //        context.delete(arrary[indexPath.row])
    //        arrary.remove(at: indexPath.row)
    //일단 주석
    //        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
    //        saveItem()
    //        tableView.deselectRow(at: indexPath, animated: true)
    //    }
    
    
    //MARK: - tableView Delegate Method
    
    //            if arrary[indexPath.row].done == false{
    //                arrary[indexPath.row].done = true
    //            }else{
    //                arrary[indexPath.row].done = false
    //            }
    //
    //            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
    //                tableView.cellForRow(at: indexPath)?.accessoryType = .none
    //            }else {
    //                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    //            }
    //      arrary[indexPath.row].setValue("completed", forKey: "title")아래코드와 같은 기능
    //
    //saveItem()
    
    
    //MARK: - add new item
    
    @IBAction func UIBarButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new Todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add item", style: .default) { action in
            
            if let currrentCategory = self.selectedCategory {
                do{
                    try self.realm.write{
                        let newitems = Item()
                        newitems.title = textField.text!
                        newitems.dateCreated = Date()
                        currrentCategory.items.append(newitems)
                    }
                } catch {
                    print("CurrentCategory error \(error)")
                }
            }
            //테이블 뷰를 불러서 재업데이트
            self.tableView.reloadData()
        }
        //self.defaults.set(self.arrary, forKey: "TodoListArray")
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    func saveItem(){
        
        self.tableView.reloadData()
    }
    
    
    func loadItem(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }
    override func updateModel(at indexPath : IndexPath){
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    realm.delete(item)
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
    }
}
//MARK: - Search bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dataCreated", ascending: true)
        
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
}

