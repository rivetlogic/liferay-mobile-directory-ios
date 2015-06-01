//
//  ServerSyncCallback.swift
//  MobilePeopleDirectory
//
//  Created by alejandro soto on 2/3/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit
import CoreData

class ServerAsyncCallback:NSObject, LRCallback {
    private var _syncable:ServerSyncableProtocol
    private var _primaryKey:String
    private var _itemsCountKey:String
    private var _listKey:String
    private var _errorHandler: ((ServerFetchResult!) -> Void)!
    var appHelper = AppHelper()
    
    init(syncable:ServerSyncableProtocol, primaryKey:String, itemsCountKey:String, listKey:String, errorHandler: ((ServerFetchResult!) -> Void)!) {
        self._syncable = syncable
        self._primaryKey = primaryKey
        self._itemsCountKey = itemsCountKey
        self._listKey = listKey
        self._errorHandler = errorHandler
    }

    func onFailure(error: NSError!) {
        switch (error.code) {
            //case -1001:
            default:
                self._errorHandler(ServerFetchResult.ConnectivityIssue)
                break;
        }
    }
    func onSuccess(result: AnyObject!) {
        var response = result as NSDictionary
        var items = response[self._listKey] as NSArray
        var activeItemsCount = response[self._itemsCountKey] as NSInteger
        println("Items retrieved from server : \(items.count)")
        
        var managedObjectContext = appHelper.getManagedContext()
        for item in items {
            // checks if item exists
            if self._syncable.itemExists(item[self._primaryKey] as NSInteger) {
                var existentItem = self._syncable.getItemById(item[self._primaryKey] as NSInteger) as NSManagedObject
                // update item with latest data
                existentItem = self._syncable.fillItem(item as NSDictionary, managedObject: existentItem)
                managedObjectContext!.save(nil)
            } else {
                self._syncable.addItem(item as NSDictionary)
            }
        }
        
        // if items unsynced retrieve entire data from server
        if (self._areItemsUnsynced(activeItemsCount)) {
        
            //self._syncable.removeAllItems()
            var session = SessionContext.createSessionFromCurrentSession()
            var asyncCallback = ServerAsyncCallback(syncable: self._syncable,
                primaryKey: self._primaryKey,
                itemsCountKey: self._itemsCountKey,
                listKey: self._listKey,
                errorHandler: self._errorHandler)
            
            session?.callback = asyncCallback
            //self._syncable.getServerData(0.0, session: &session!)
            
        }
    }
    
    private func _areItemsUnsynced(serverActiveItemsCount:NSInteger) -> Bool {
        let storedItemsCount = self._syncable.getItemsCount()
        return (storedItemsCount != serverActiveItemsCount)
    }
}
