//
//  PeopleDirectoryHelper.swift
//  MobilePeopleDirectory
//
//  Created by alejandro soto on 1/18/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit
import CoreData


class PeopleDao:ServerSyncableProtocol {
    
    var imageHelper = ImageHelper()
    var appHelper = AppHelper()
    
    // request data to liferay server
    func getServerData(timestamp: Double, inout session:LRSession) {

        let peopleDirectoryService = LRPeopledirectoryService_v62(session: session)
        var error: NSError?
        
        // request data based on last local storage user modified unix timestamp
        var users = peopleDirectoryService.usersFetchByDateWithModifiedEpochDate(timestamp, error: &error)
    }
    
    
    // gets the last person modified
    func getLastModifiedDate() -> NSDate {
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

    
    // check if user exist
    func itemExists(id:NSInteger) -> Bool {
        var managedObjectContext = appHelper.getManagedContext()
        var fetchRequest = NSFetchRequest()
        fetchRequest.entity = Person.EntityDescription(inManagedObjectContext: managedObjectContext!)
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectResultType
        fetchRequest.predicate = NSPredicate(format: "userId = %i", id)
        
        if let result = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) {
            if result.count > 0 {
                return true
            }
        }
        
        return false
    }
    
    // find user by id
    func getItemById(userId:NSInteger) -> NSManagedObject {
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
    
    // fill new or update existing managed class object/person
    func fillItem(itemData: NSDictionary, managedObject: NSManagedObject) -> NSManagedObject {
        var person = managedObject as Person
        person.fullName = itemData["fullName"] as NSString
        person.birthDateEpoch = itemData["birthDate"] as Double
        person.city = itemData["city"] as NSString
        person.wasDeleted = itemData["deleted"] as Bool
        person.emailAddress = itemData["emailAddress"] as NSString
        person.jobTitle = itemData["jobTitle"] as NSString
        person.male = itemData["male"] as Bool
        person.modifiedDateEpoch = itemData["modifiedDate"] as Double
        person.screenName = itemData["screenName"] as NSString
        person.skypeName = itemData["skypeName"] as NSString
        person.userId = itemData["userId"] as NSInteger
        person.userPhone = itemData["userPhone"] as NSString
        
        if let portraitUrl = itemData["portraitUrl"] as? NSString {
            if imageHelper.hasUserImage(portraitUrl) {
                person.portraitUrl = itemData["portraitUrl"] as NSString
                person.portraitImage = imageHelper.getImageData(LiferayServerContext.server + person.portraitUrl)
            } else {
                person.portraitUrl = ""
            }
        }
        
        return person;
    }
    
    // removes everything from persons local storage
    func removeAllItems() {
        var managedObjectContext = appHelper.getManagedContext()
        var usersData = self.getAllUsers()
        for user in usersData {
            managedObjectContext?.deleteObject(user)
            managedObjectContext?.save(nil)
        }
    }
    
    func getItemsCount() -> NSNumber {
        var managedObjectContext = appHelper.getManagedContext()
        var usersData = self.getAllUsers()
        return usersData.count
    }
    
    func getAllUsers() -> [NSManagedObject] {
        var managedObjectContext = appHelper.getManagedContext()
        let request = NSFetchRequest(entityName: "Person")
        var usersData = managedObjectContext?.executeFetchRequest(request, error: nil) as [NSManagedObject]
        return usersData
    }
}
