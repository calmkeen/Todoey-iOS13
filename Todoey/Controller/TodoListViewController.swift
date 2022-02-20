//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var arrary = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loaditem()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loaditem()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
//        if let items = defaults.array( forKey: "TodoListArray") as? [Item]{
//            arrary = items
//        }
        // Do any additional setup after loading the vie
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrary.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = arrary[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
//        if arrary[indexPath.row].done == true{
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    //MARK: - one
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(arrary[indexPath.row])
        //삭제 기능 순서 중요
        context.delete(arrary[indexPath.row])
        arrary.remove(at: indexPath.row)
        
        //일단 주석
        arrary[indexPath.row].done = !arrary[indexPath.row].done
        
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
        saveItem()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - add new item
    
    @IBAction func UIBarButton(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "add new Todo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add item", style: .default) { action in
            
        
            
            let newitems = Item(context: self.context)
            newitems.title = textfield.text!
            newitems.done = false
            newitems.parentCategory = self.selectedCategory
            
            self.arrary.append(newitems)
            self.saveItem()
            
            //self.defaults.set(self.arrary, forKey: "TodoListArray")
            
            
        }
        
        
        alert.addTextField { (alertTExtField) in
            alertTExtField.placeholder = "create new items"
            textfield = alertTExtField
            print("now")
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem(){
        
        self.tableView.reloadData()
    }
    
    func loaditem(with request: NSFetchRequest <Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name! )
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        request.predicate = compoundPredicate
        
        do {
        arrary = try context.fetch(request)
        } catch {
            print("error load item \(error)")
        }

        }
    

}
//MARK: - Search bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request:  NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title Contains %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loaditem(with: request, predicate:)
//        do{
//            try context.save()
//        } catch {
//            print("Error saving \(error)")
//        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loaditem()
                
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
}
