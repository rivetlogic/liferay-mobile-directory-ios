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
    
    func removeAllData(managedObjectContext: NSManagedObjectContext) {
        let request = NSFetchRequest(entityName: "Person")
        var usersData = managedObjectContext.executeFetchRequest(request, error: nil) as [NSManagedObject]
        for user in usersData {
            managedObjectContext.deleteObject(user)
            managedObjectContext.save(nil)
        }
    }
    
    func fetchFromServer(managedObjectContext: NSManagedObjectContext) -> ServerFetchResult {
        // TODO: remove this, right now is resetting the table data
        self.removeAllData(managedObjectContext)
        
        // request data from server and stores it
        // TODO: refactor the following lines to cache server data properly
        if !SessionContext.hasSession {
            if !SessionContext.loadSessionFromStore() {  // creates a new session using creds from keychain.  Returns false if no creds in keychain.
            return ServerFetchResult.CredIssue
            }
        }
        let peopleDirectoryService = LRPeopledirectoryService_v62(session: SessionContext.createSessionFromCurrentSession())
        var error: NSError?
        var users = peopleDirectoryService.fetchAll(&error)
        if error != nil {return ServerFetchResult.ConnectivityIssue}
//TODO:  Need to determine if the error is due to credential failure (return .CredIssue) or a network failure.  In the case of the network failure, might want to expand possible ServerFetchResult error types and return something more specific
        var usersList = users["users"] as NSArray
        
        for user in usersList {
            var person = Person(insertIntoManagedObjectContext: managedObjectContext)
            person = self.fillUser(user as NSDictionary, person: person)
            managedObjectContext.save(nil)
        }
        return ServerFetchResult.Success
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
