//
//  ViewController.swift
//  MyCars
//
//  Created by Paul on 15.01.2019.
//  Copyright © 2019 Paul. All rights reserved.
//
//  Paul's notes: This is a chance for autolayout practice.

import UIKit
import CoreData

class ViewController: UIViewController {
    //Paul's notes: Much better then before. We have controller var. But we could do even better and make it static
    var context: NSManagedObjectContext!
    // lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var lastTimeStartedLabel: UILabel!
    @IBOutlet weak var numberOfTripsLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var myChoiceImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func getDataFromFile() {
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mark != nil")
        
        var records = 0
        do {
            let count = try context.count(for: fetchRequest) //Paul's note: welldone! There is a common mistake of using just for getting total rows
            // let unefficientCount = try context.fetch(fetchRequest).count
            records = count
            print("There is some data")
        } catch  {
            print(error.localizedDescription)
        }
        //Paul's note: guard and assert statements should be used to highlight right and wrong goings. Stadard if would do just fine here
        guard records == 0 else { return }
        // Paul's note: Instructor claims Bundle = our project, but obviously it is a class with static vars and methods
        let pathToFile = Bundle.main.path(forResource: "data", ofType: "plist")

        // Paul's note: I would rather use url, so we could work with files in iCloud too
//        if let urlToFile = Bundle.main.url(forResource: "data", withExtension: "plist") {
//            let dataArray = NSArray(contentsOf: urlToFile)
//        }
        
        let dataArray = NSArray(contentsOfFile: pathToFile!)!
        // Paul's note: there are better (more strictly typed) ways to work with arrays. At least we could:
        //  let dataArray = NSArray(contentsOfFile: pathToFile!)! as? Array<NSDictionary>
        
        for dictionary in dataArray {
            let entity = NSEntityDescription.entity(forEntityName: "Car", in: context)
            // Paul's note: I would rather write:
            // let entity = Car(context: context)
            // What if we decide to rename class Car to Auto? It will compile and crush at some point of runtime
            let car = NSManagedObject(entity: entity!, insertInto: context) as! Car
            let carDictionary = dictionary as! NSDictionary
        }
    }

    @IBAction func segmentedCtrlPressed(_ sender: UISegmentedControl) {
    }
    
    @IBAction func startEnginePressed(_ sender: UIButton) {
    }
    @IBAction func rateItPressed(_ sender: UIButton) {
    }
}

