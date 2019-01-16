//
//  Car+CoreDataProperties.swift
//  MyCars
//
//  Created by Paul on 16.01.2019.
//  Copyright © 2019 Paul. All rights reserved.
//
//

import Foundation
import CoreData
 //Paul's notes: Instructor warned about compile issues, but the did not happen

extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var lastStarted: NSDate?
    @NSManaged public var mark: String?
    @NSManaged public var model: String?
    @NSManaged public var myChoice: Bool //Paul's notes: accordind to instructor, it should be presented as NSNumber?
    @NSManaged public var rating: Double //Paul's notes: same with rating and Int16
    @NSManaged public var timesDriven: Int16 //Paul's notes: the scalar types or XCode version must be the cause for the difference
    @NSManaged public var tintColor: NSObject?

}
