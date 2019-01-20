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
    
    // Paul's note: well done! Init with closure, correct lazy usage
    lazy var dateFormatter: DateFormatter  = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    //MARK: UITableViewDataSource delegate methods (delegate linked via Storyboard)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") {
            let date = array[indexPath.row]
            cell.textLabel?.text = dateFormatter.string(from: date)
            // Paul's note: could just go without dateFormatter and get a LOCALIZED one
            cell.textLabel?.text = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
    }
    
    // Paul's note: not very good Section Header usage. replaced with NavigationItem.Title in storyboard
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My happy meal time"
    } */
}

