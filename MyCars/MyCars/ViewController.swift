//
//  ViewController.swift
//  MyCars
//
//  Created by Paul on 15.01.2019.
//  Copyright © 2019 Paul. All rights reserved.
//
//  Paul's notes: This is a chance for autolayout practice.
//  All this pllist business is better done with codable
//  Paul's TODO:
//  Make sure to check all those "!" "as!" and "as?" - make use of guard, assert, inits, convert funcs
//  Refine data model and consider making entity attributes non-optional. Think about scalar vs ref types.


import UIKit
import CoreData

class ViewController: UIViewController {
    //Paul's notes: Much better then before. We have controller var. But we could do even better and make it static
    var context: NSManagedObjectContext!
    // lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCar: Car! //Paul's notes: better use regulal Optional without implicit unwrapping
    
    // https://en.wikipedia.org/wiki/Lamborghini_Murciélago
    // https://ru.wikipedia.org/wiki/Ferrari_Enzo
    // ...
    // https://en.wikipedia.org/wiki/BMW_X6
    
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
        myChoiceImageView.image = UIImage(imageLiteralResourceName: "checkmark")
        getDataFromFile()
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        let mark = segmentedControl.titleForSegment(at: 0) // Paul's note: to keep thing in sync it is better to do titleForSegment(at: segmentedControl.selectedSegmentIndex)
        debugPrint("mark \(mark ?? "unknown")")
        fetchRequest.predicate = NSPredicate(format: "mark == %@", mark!)
        
        do {
            let results = try context.fetch(fetchRequest)
            selectedCar = results[0] // Paul's note: If we fetch nothing (fetch fails or no rows mathching the predice, results[0] will crash the app
            // Paul's note: line above can be replaced with the following
            // assert(results.count == 1, "Returned unexpexted number of rows for Car")
            // selectedCar = results.first!// we can safely unwrap because we know we have exactly one element
            insertDataFrom(selectedCar: selectedCar)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func insertDataFrom(selectedCar: Car) {
        // Paul's note: UI updating stuff is better incaplulated in a dedicated func
        // carImageView.image = UIImage(data: selectedCar.imageData as! data)
        if let carImageData = selectedCar.imageData  {
            carImageView.image = UIImage(data: carImageData as Data)
        } else {
            carImageView.image = nil
        }
        markLabel.text = selectedCar.mark
        modelLabel.text = selectedCar.model
        myChoiceImageView.isHidden = !selectedCar.myChoice  // replaced with scalar value type
        ratingsLabel.text = "Rating: \(selectedCar.rating) / 10.0" // replaced with scalar value type
        numberOfTripsLabel.text = "Number of trips: \(selectedCar.timesDriven)"
        
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        lastTimeStartedLabel.text = "Last time started: \(df.string(from: (selectedCar.lastStarted! as Date)))"
        segmentedControl.tintColor = (selectedCar.tintColor as? UIColor) // Paul's note: there might be more elegant way to work with Transformable. "as?" is just much more appropriate here.
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
            
            car.mark = carDictionary["mark"] as? String
            car.model = carDictionary["model"] as? String
            car.rating = carDictionary["rating"] as! Double // as? NSNumber
            car.lastStarted = carDictionary["lastStarted"] as? NSDate
            car.timesDriven = carDictionary["timesDriven"] as! Int16
            car.myChoice = carDictionary["myChoice"] as! Bool
            
            if let imageName = carDictionary["imageName"] as? String, let url = URL(string: imageName) {
                if let imageDataFromURL = try? Data(contentsOf: url), let image = UIImage(data: imageDataFromURL) {
                    //let imageDataAsPNG2 = UIImagePNGRepresentation(image) // deprecated
                    let imageData = image.pngData() // Recompress data
                    car.imageData = NSData(data: imageData!)
                }
                
            }
            if let colorDictionary = carDictionary["tintColor"] as? NSDictionary {
                car.tintColor = getColor(colorDictionary: colorDictionary)
            }
            
        }
        // Paul's note: Instructor seems to have forgotten to save context?
        // Use saveContext from AppDelegate or maybe now it is all autosaved
        do {
            try context.save()
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    private func getColor(colorDictionary: NSDictionary) -> UIColor {
        let red = colorDictionary["red"] as! NSNumber // Paul's note: as CGFloat right away
        let green = colorDictionary["green"] as! NSNumber
        let blue = colorDictionary["blue"] as! NSNumber

        return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
    }

    @IBAction func segmentedCtrlPressed(_ sender: UISegmentedControl) {
        let mark = sender.titleForSegment(at: sender.selectedSegmentIndex) // Paul's note: "if let"
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mark == %@", mark!)
        do {
            let results = try context.fetch(fetchRequest)
            selectedCar = results[0] // Paul's note: check count, use ".first"
            insertDataFrom(selectedCar: selectedCar)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func startEnginePressed(_ sender: UIButton) {
        let timesDriven = selectedCar.timesDriven
        selectedCar.timesDriven = timesDriven + 1 // No NSNumber, no optionality due to scalar types
        // Paul's note: can be done with oneliner:
        // selectedCar.timesDriven += 1
        selectedCar.lastStarted = NSDate()
        
        do { // Paul's note: incapsulate into a function - it will called from several places obviously
            try context.save()
            insertDataFrom(selectedCar: selectedCar) // Paul's note: property observers exist for this
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func rateItPressed(_ sender: UIButton) {
        let ac = UIAlertController(title: "Rate it", message: "Rate this car please", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            let textField =  ac.textFields?[0] // Paul's note: ac.textFields?.first is more error prone. "if let" wants to be here instad of "let"
            self.update(rating: (textField?.text)!)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        ac.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        ac.addAction(ok)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    
    func update(rating: String) {
        selectedCar.rating = Double(rating)!
        do { // Paul's note: incapsulate into a function - it will called from several places obviously
            try context.save()
            insertDataFrom(selectedCar: selectedCar) // Paul's note: property observers exist for this
        } catch  {
            let ac = UIAlertController(title: "Wrong value", message: "Wrong", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            ac.addAction(ok)
            present(ac, animated: true)
            
            print(error.localizedDescription)
        }
    }
}

