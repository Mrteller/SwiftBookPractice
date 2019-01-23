//
//  ViewController.swift
//  Meal time
//
//  Created by Paul on 20.01.2019.
//  Copyright © 2019 Paul. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    var context: NSManagedObjectContext!
    @IBOutlet weak var tableView: UITableView!
    var array = [Date]()
    var person: Person!
    
    // Paul's note: well done! Init with closure, correct lazy  usage
    lazy var dateFormatter: DateFormatter  = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let personName = "Max"
        let fetchRequest : NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", personName)
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                person = Person(context: context)
                person.name = personName
            } else {
                person = results.first
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    //MARK: UITableViewDataSource delegate methods (delegate linked via Storyboard)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let meals = person.meals else { return 1 }
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") {
            
            guard let meal = person.meals?[indexPath.row] as? Meal, let mealDate = meal.date else
            {
                return cell
            }
            cell.textLabel?.text = dateFormatter.string(from: mealDate as Date) // Paul's note:NSDate is bridged to Date so we can avoid optionality if cast it here, not before
            // Paul's note: could just go without dateFormatter and get a LOCALIZED one
            // cell.textLabel?.text = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
    }
    
    // Paul's note: not very good Section Header usage. replaced with NavigationItem.Title in storyboard
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My happy meal time"
    } */
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let meal = Meal(context: context)
        meal.date = NSDate()
        
        let meals = person.meals?.mutableCopy() as? NSMutableOrderedSet
        meals?.add(meal)
        person.meals = meals
        
        // Paul's note: we could just do it much more efficient and natural
        // person.addToMeals(meal) // or even more flexible if we wanted sorting or adding at the beginning
        // person.insertIntoMeals(meal, at: 0)
        // Paul's note: We have a func saveContext - why do we repeat ouselves?
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), userInfo \(error.userInfo)")
        }
        
        
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let mealToDelete = person.meals?[indexPath.row] as? Meal, editingStyle == .delete else {return}
        context.delete(mealToDelete)
        // Paul's note: better way to do the same
        // person.removeFromMeals(mealToDelete)
        // Paul's note: or we could do it in one line and avoid typecasting and optionality:
        // person.removeFromMeals(at: indexPath.row)
        // Paul's note: We have a func saveContext - why do we repeat ouselves?
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), userInfo \(error.userInfo)")
            return // Paul's note: need to add return here to maintain consistensy between DB and tableView
        }
        tableView.deleteRows(at: [indexPath], with: .automatic) // Paul's note: deleteRows doesn't trow, so we can move it out of try-catch block
    }
}

