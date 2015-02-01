//
//  PeopleDirectoryHelper.swift
//  MobilePeopleDirectory
//
//  Created by alejandro soto on 1/18/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit
import CoreData

enum ServerFetchResult {
    case Success
    case CredIssue
    case ConnectivityIssue
    case PermanentFailure
}


class PeopleDao {
    
    var imageHelper = ImageHelper()
    var appHelper = AppHelper()
    
    // gets the last person modified
    func getLastPersonModified() -> NSDate {
        var managedObjectContext = appHelper.getManagedContext()
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = Person.EntityDescription(inManagedObjectContext: managedObjectContext!)
        fetchRequest.sortDescriptors = [ NSSortDescriptor(key: "modifiedDateEpoch", ascending: false) ]
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectResultType
 
        var error : NSError?
        if let result = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) {
            if result.count > 0 {
                var lastModifiedPerson = result[0] as Person
                return lastModifiedPerson.modifiedDate
            }
        }
        return NSDate(timeIntervalSince1970: 0.0)
    }
    
    func fetchFromServer() -> ServerFetchResult {
        var managedObjectContext = appHelper.getManagedContext()
        let lastModifiedDate = self.getLastPersonModified()
       
        // request data from server and stores it
        if !SessionContext.hasSession {
            if !SessionContext.loadSessionFromStore() {  // creates a new session using creds from keychain.  Returns false if no creds in keychain.
            return ServerFetchResult.CredIssue
            }
        }
        let peopleDirectoryService = LRPeopledirectoryService_v62(session: SessionContext.createSessionFromCurrentSession())
        var error: NSError?
        
        // request data based on last local storage user modified unix timestamp
        var users = peopleDirectoryService.usersFetchByDateWithModifiedEpochDate(lastModifiedDate.timeIntervalSince1970 * 1000, error: &error)
        if error != nil {return ServerFetchResult.ConnectivityIssue}

        //TODO:  Need to determine if the error is due to credential failure (return .CredIssue) or a network failure.  In the case of the network failure, might want to expand possible ServerFetchResult error types and return something more specific
        var usersList = users["users"] as NSArray
        print("User entries retrieved from server: \(usersList.count)")
        for user in usersList {
            // checks if user exists
            if self.userExists(user["userId"] as NSInteger) {
                var existentUser = self.getUserById(user["userId"] as NSInteger) as Person
                // user has deleted flag set in true user will be removed, else just update current user
                if (user["deleted"] as Bool) {
                    managedObjectContext!.deleteObject(existentUser)
                    managedObjectContext!.save(nil)
                } else {
                    // update user with latest data
                    existentUser = self.fillUser(user as NSDictionary, person: existentUser)
                    managedObjectContext!.save(nil)
                }
            } else {
                var person = Person(insertIntoManagedObjectContext: managedObjectContext!)
                person = self.fillUser(user as NSDictionary, person: person)
                managedObjectContext!.save(nil)
            }
        }
        return ServerFetchResult.Success
    }
    
    // check if user exist
    func userExists(userId:NSInteger) -> Bool {
        var managedObjectContext = appHelper.getManagedContext()
        var fetchRequest = NSFetchRequest()
        fetchRequest.entity = Person.EntityDescription(inManagedObjectContext: managedObjectContext!)
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectResultType
        fetchRequest.predicate = NSPredicate(format: "userId = %i", userId)
        
        if let result = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) {
            if result.count > 0 {
                return true
            }
        }
        
        return false
    }
    
    // find user by id
    func getUserById(userId:NSInteger) -> NSManagedObject {
        var managedObjectContext = appHelper.getManagedContext()
        var fetchRequest = NSFetchRequest()
        fetchRequest.entity = Person.EntityDescription(inManagedObjectContext: managedObjectContext!)
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectResultType
        fetchRequest.predicate = NSPredicate(format: "userId = %i", userId)
        
        if let result = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) {
            if result.count > 0 {
                return result[0] as NSManagedObject
            }
        }
        
        return NSManagedObject() // TODO: fix, if this happens app will fail
    }
    
    func fillUser(userData: NSDictionary, person: Person) -> Person {
        person.fullName = userData["fullName"] as NSString
        person.birthDateEpoch = userData["birthDate"] as Double
        person.city = userData["city"] as NSString
        person.wasDeleted = userData["deleted"] as Bool
        person.emailAddress = userData["emailAddress"] as NSString
        person.jobTitle = userData["jobTitle"] as NSString
        person.male = userData["male"] as Bool
        person.modifiedDateEpoch = userData["modifiedDate"] as Double
        person.portraitUrl = userData["portraitUrl"] as NSString
        person.screenName = userData["screenName"] as NSString
        person.skypeName = userData["skypeName"] as NSString
        person.userId = userData["userId"] as NSInteger
        person.userPhone = userData["userPhone"] as NSString
        person.portraitImage = imageHelper.getImageData(LiferayServerContext.server + person.portraitUrl)
        return person;
    }
}
