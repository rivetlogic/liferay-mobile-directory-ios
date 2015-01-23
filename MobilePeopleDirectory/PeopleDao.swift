//
//  PeopleDirectoryHelper.swift
//  MobilePeopleDirectory
//
//  Created by alejandro soto on 1/18/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit
import CoreData

class PeopleDao {

    func removeAllData(managedObjectContext: NSManagedObjectContext) {
        let request = NSFetchRequest(entityName: "Person")
        var usersData = managedObjectContext.executeFetchRequest(request, error: nil) as [NSManagedObject]
        for user in usersData {
            managedObjectContext.deleteObject(user)
            managedObjectContext.save(nil)
        }
    }
    
    func fetchFromServer(managedObjectContext: NSManagedObjectContext) {
        // TODO: remove this, right now is resetting the table data
        self.removeAllData(managedObjectContext)
        
        // request data from server and stores it
        // TODO: refactor the following lines to cache server data properly
        let peopleDirectoryService = LRPeopledirectoryService_v62(session: SessionContext.createSessionFromCurrentSession())
        var error: NSError?
        var users = peopleDirectoryService.fetchAll(&error)
        var usersList = users["users"] as NSArray
        
        for user in usersList {
            var person = Person(insertIntoManagedObjectContext: managedObjectContext)
            person = self.fillUser(user as NSDictionary, person: person)
            managedObjectContext.save(nil)
        }
    }
    
    func fillUser(userData: NSDictionary, person: Person) -> Person {
        person.fullName = userData["fullName"] as NSString
        person.birthDate = userData["birthDate"] as Double
        person.city = userData["city"] as NSString
        person.wasDeleted = userData["deleted"] as Bool
        person.emailAddress = userData["emailAddress"] as NSString
        person.jobTitle = userData["jobTitle"] as NSString
        person.male = userData["male"] as Bool
        person.modifiedDate = userData["modifiedDate"] as Double
        person.portraitUrl = userData["portraitUrl"] as NSString
        person.screenName = userData["screenName"] as NSString
        person.skypeName = userData["skypeName"] as NSString
        person.userId = userData["userId"] as NSInteger
        person.userPhone = userData["userPhone"] as NSString
        return person;
    }
}
