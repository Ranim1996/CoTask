//
//  TableViewController.swift
//  CoTask
//
//  Created by Rawan Abou Dehn on 13/04/2021.
//

import UIKit

//final class Todo {
//    let title: String
//    let date: Date
//    var isImportant: Bool
//    var isFinished: Bool
//
//    init(title: String) {
//        self.title = title
//        self.date = Date()
//        self.isImportant = false
//        self.isFinished = false
//    }
//}

class TableViewController: UITableViewController {

    var todos = [Task]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        for i in 1...10 {
//            todos.append(Todo(title: "Todo #\(i)"))
//        }
//    }
    
    // Mark: - Table view delegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //let important = importantAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
//    func importantAction(at indexPath: IndexPath) -> UIContextualAction {
//        let todo = todos[indexPath.row]
//        let action = UIContextualAction(style: .normal, title: "Important") { (action, view, completion) in
//            todo.isImportant = !todo.isImportant // toggle
//            completion(true)
//        }
//
//        action.image = #imageLiteral(resourceName: "Alarm")
//        action.backgroundColor = todo.isImportant ? .purple : .gray
//
//        return action
//    }
   
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.todos.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completion(true)
        }
        
        action.image = #imageLiteral(resourceName: "Trash")
        action.backgroundColor = .red
        
        return action
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = completeAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [complete])
    }
    
    func completeAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Complete") { (action, view, completion) in
            self.todos.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completion(true)
        }
        
        action.image = #imageLiteral(resourceName: "Check")
        action.backgroundColor = .green
        
        return action
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)

        // Configure the cell...
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.title
        //cell.detailTextLabel?.text = todo.date.description

        return cell
    }
}
