//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  loaditem()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
            //MARK: - tableview datasource method
        
//        if let items = defaults.array( forKey: "TodoListArray") as? [Item]{
//            arrary = items
//        }
        // Do any additional setup after loading the vie
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        } else {
            cell.textLabel?.text  = "no items added"
        }
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(arrary[indexPath.row])
        //삭제 기능 순서 중요
//        context.delete(arrary[indexPath.row])
//        arrary.remove(at: indexPath.row)
        //일단 주석
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
        

        //MARK: - tableView Delegate Method
      
//        if arrary[indexPath.row].done == false{
//            arrary[indexPath.row].done = true
//        }else{
//            arrary[indexPath.row].done = false
//        }
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//      arrary[indexPath.row].setValue("completed", forKey: "title")아래코드와 같은 기능
        //
    //saveItem()

    
    //MARK: - add new item
    
    @IBAction func UIBarButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new Todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add item", style: .default) { action in
            
        
            
//            let newitems = Item(context: self.context)
//            newitems.title = textfield.text!
//            newitems.done = false
//            newitems.parentCategory = self.selectedCategory
//            self.arrary.append(newitems)
            
            self.saveItem()
            
            //self.defaults.set(self.arrary, forKey: "TodoListArray")
            
            
        }
        
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
    

}
//MARK: - Search bar Methods
//extension TodoListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request:  NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title Contains %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loaditem(with: request, predicate: predicate)
//    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0{
//            loaditem()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//
//        }
//    }
//}
