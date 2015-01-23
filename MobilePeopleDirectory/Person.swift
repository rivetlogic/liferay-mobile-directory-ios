//
//  Person.swift
//  MobilePeopleDirectory
//
//  Created by alejandro soto on 1/18/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import Foundation
import CoreData

public class Person: NSManagedObject {

    public convenience init(insertIntoManagedObjectContext context: NSManagedObjectContext) {
        self.init(entity: Person.EntityDescription(inManagedObjectContext: context), insertIntoManagedObjectContext: context)
    }
    
    
    class func EntityDescription(inManagedObjectContext context:NSManagedObjectContext) -> NSEntityDescription {
        return NSEntityDescription.entityForName("Person", inManagedObjectContext: context)!
    }
    
    @NSManaged var fullName: String
    @NSManaged var jobTitle: String
    @NSManaged var birthDateEpoch: Double
    @NSManaged var city: String
    @NSManaged var wasDeleted: Bool
    @NSManaged var emailAddress: String
    @NSManaged var male: Bool
    @NSManaged var modifiedDateEpoch: Double
    @NSManaged var portraitUrl: String
    @NSManaged var screenName: String
    @NSManaged var skypeName: String
    @NSManaged var userId: NSNumber
    @NSManaged var userPhone: String
    
    
    var birthDate: NSDate {
        get{
            return NSDate(timeIntervalSince1970: birthDateEpoch / 1000)
        }
        set {
            self.birthDateEpoch = newValue.timeIntervalSince1970
        }
    }
    
    
   var modifiedDate: NSDate {
        get{
            return NSDate(timeIntervalSince1970: modifiedDateEpoch / 1000)
        }
        set {
            self.modifiedDateEpoch = newValue.timeIntervalSince1970
        }
    }
    
    
}
