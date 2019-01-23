//
//  Meal+CoreDataProperties.swift
//  Meal time
//
//  Created by Paul on 23.01.2019.
//  Copyright © 2019 Paul. All rights reserved.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var place: String?
    @NSManaged public var person: Person?

}
