//
//  TableViewController.swift
//  CoreDataDemo
//
//  Created by Paul on 13.01.2019.
//  General Paul's notes:
//  Naming IS important. Change meaningless names to meaningfull ones.
//  Force unwrap is used dangerously
//  What's the point of manually messing with arrays if we have NSFetchedResultsController?

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var toDoItems = [Task]()
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: NSLocalizedString("Add Task", comment: "UIAlert title"), message: "add new task", preferredStyle: .alert) // Paul's note: Always wrap strings in NSLocalizedString()
        let ok = UIAlertAction(title: NSLocalizedString("OK", comment: "UIAlert OK action"), style: .default) { action in
            let textField = ac.textFields?[0]
            self.saveTask(taskToDo: (textField?.text)!)
            //self.toDoItems.insert((textField?.text)!, at: 0) // TODO: don't leave it like this! Let's think instructor was in terrible rush.
            self.tableView.reloadData() // TODO: check for memory cycle
            // Paul's note: using .reloadData() is definitely too much. insertRows(at: index, with: .automatic) would be nicer.
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "UIAlert Cancel action"), style: .cancel, handler: nil) // Paul's note: better use style: .cancel instead of .default
        ac.addTextField(configurationHandler: nil) // Paul's note: better than making empty closure and better move it up
        ac.addAction(ok)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
    
    func saveTask(taskToDo: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate // Paul's note: creating a static var is preferable
        let context = appDelegate.persistentContainer.viewContext
        // Paul's note: there is an object oriented, strictly typed way to do the following
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! Task
        // here is how: let taskObject = Task(context: context)
        taskObject.taskToDo = taskToDo
        
        do {
            try context.save()
            toDoItems.append(taskObject)
            print("Saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // Paul's note: always give super a chance to do its job
        // Paul's note: If you find yourself copy-pasting, it is highly likely you doing something wrong
        let appDelegate = UIApplication.shared.delegate as! AppDelegate // Paul's note: creating a static var is preferable
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            toDoItems = try context.fetch(fetchRequest)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = toDoItems[indexPath.row]
        cell.textLabel?.text = task.taskToDo
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
