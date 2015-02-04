//
//  ServerSyncable.swift
//  MobilePeopleDirectory
//
//  Created by alejandro soto on 2/1/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//
// Basic operations to help sync the local storage with liferay server data

import Foundation
import CoreData

enum ServerFetchResult {
    case Success
    case CredIssue
    case ConnectivityIssue
    case PermanentFailure
}

protocol ServerSyncableProtocol {
    
    func addItem(itemData:NSDictionary)
    func fillItem(itemData: NSDictionary, managedObject: NSManagedObject) -> NSManagedObject // fill/update the managed object
    func getLastModifiedDate() -> NSDate // returns last item modified date
    func getServerData(timestamp:Double, inout session:LRSession) // returns data from server using the last item modified timestamp
    func getItemsCount() -> NSNumber // gets the local stored items count
    func getItemById(userId:NSInteger) -> NSManagedObject   // retrieves existent item from local db
    func itemExists(id:NSInteger) -> Bool // verifies if item exists locally
    func removeAllItems() // remove all from local storage
    
}