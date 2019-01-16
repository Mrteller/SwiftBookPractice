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
    }

    @IBAction func segmentedCtrlPressed(_ sender: UISegmentedControl) {
    }
    
    @IBAction func startEnginePressed(_ sender: UIButton) {
    }
    @IBAction func rateItPressed(_ sender: UIButton) {
    }
}

