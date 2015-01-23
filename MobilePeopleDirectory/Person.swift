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
    @NSManaged private var birthDate_: NSDate?
    @NSManaged var city: String
    @NSManaged var wasDeleted: Bool
    @NSManaged var emailAddress: String
    @NSManaged var male: Bool
    @NSManaged private var modifiedDate_: NSDate?
    @NSManaged var portraitUrl: String
    @NSManaged var screenName: String
    @NSManaged var skypeName: String
    @NSManaged var userId: NSNumber
    @NSManaged var userPhone: String
    
    
    var birthDate: Double {
        get{
            if let val = self.birthDate_ {
                return val.timeIntervalSince1970
            }
            return 0
        }
        set {
            self.birthDate_ = NSDate(timeIntervalSince1970: newValue / 1000)
        }
    }
    
    var modifiedDate: Double {
        get{
            if let val = self.modifiedDate_ {
                return val.timeIntervalSince1970
            }
            return 0
        }
        set {
            self.modifiedDate_ = NSDate(timeIntervalSince1970: newValue / 1000)
        }
    }
    
    
}
