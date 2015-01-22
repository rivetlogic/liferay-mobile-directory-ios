//
//  Person.swift
//  MobilePeopleDirectory
//
//  Created by alejandro soto on 1/18/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

    @NSManaged var fullName: String
    @NSManaged var jobTitle: String
    @NSManaged var birthDate: NSNumber
    @NSManaged var city: String
    @NSManaged var wasDeleted: Bool
    @NSManaged var emailAddress: String
    @NSManaged var male: Bool
    @NSManaged var modifiedDate: NSNumber
    @NSManaged var portraitUrl: String
    @NSManaged var screenName: String
    @NSManaged var skypeName: String
    @NSManaged var userId: NSNumber
    @NSManaged var userPhone: String
}
