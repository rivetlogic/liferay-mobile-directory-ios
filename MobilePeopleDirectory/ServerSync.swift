//
//  ServerSync.swift
//  MobilePeopleDirectory
//
//  Created by alejandro soto on 2/1/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit
import CoreData

class ServerSync {
    
    private var _syncable:ServerSyncableProtocol
    private var _key:String
    private var _localEntity:String
    
    var appHelper = AppHelper()
    
    init(syncable:ServerSyncableProtocol, key:String, localEntity:String) {
        self._syncable = syncable
        self._key = key
        self._localEntity = localEntity
    }
    
    private func _areItemsUnsynced() -> Bool {
        let storedItemsCount = self._syncable.getItemsCount()
        let serverActiveItemsCount = self._syncable.getServerActiveItemsCount()
        return (storedItemsCount != serverActiveItemsCount)
    }
    
    // starts the local storage sync against liferay server
    func syncData() -> ServerFetchResult {
        if !SessionContext.hasSession {
            if !SessionContext.loadSessionFromStore() {  // creates a new session using creds from keychain.  Returns false if no creds in keychain.
                return ServerFetchResult.CredIssue
            }
        }

        var lastModifiedDate = self._syncable.getLastModifiedDate() // returns the last item modified date
        var timestamp = lastModifiedDate.timeIntervalSince1970 * 1000
        
        var items = NSArray()
        
        // if items unsynced retrieve entire data from server
        if (self._areItemsUnsynced()) {
            self._syncable.removeAllItems()
            items = self._syncable.getServerData(0)
        } else {
            items = self._syncable.getServerData(timestamp)
        }

        print("Items retrieved from server : \(items.count)")
        var managedObjectContext = appHelper.getManagedContext()
        for item in items {
            // checks if item exists
            if self._syncable.itemExists(item[self._key] as NSInteger) {
                var existentItem = self._syncable.getItemById(item[self._key] as NSInteger) as NSManagedObject
                // item has deleted flag set in true, item will be removed, else just update current item
                if (item["deleted"] as Bool) {
                    managedObjectContext!.deleteObject(existentItem)
                    managedObjectContext!.save(nil)
                } else {
                    // update item with latest data
                    existentItem = self._syncable.fillItem(item as NSDictionary, managedObject: existentItem)
                    managedObjectContext!.save(nil)
                }
            } else {
                let entity =  NSEntityDescription.entityForName(self._localEntity, inManagedObjectContext: managedObjectContext!)
                var itemManaged = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext!)
                itemManaged = self._syncable.fillItem(item as NSDictionary, managedObject: itemManaged)
                managedObjectContext!.save(nil)
            }
            
            
        }
        return ServerFetchResult.Success
    }
    
}
