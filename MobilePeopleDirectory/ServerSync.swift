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
    private var _primaryKey:String
    private var _itemsCountKey:String
    private var _listKey:String
    private var _errorHandler:((ServerFetchResult!) -> Void)
    
    var appHelper = AppHelper()
    
    init(syncable:ServerSyncableProtocol, primaryKey:String, itemsCountKey:String, listKey:String, errorHandler: ((ServerFetchResult!) -> Void)!) {
        self._syncable = syncable
        self._primaryKey = primaryKey
        self._itemsCountKey = itemsCountKey
        self._listKey = listKey
        self._errorHandler = errorHandler
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
        
        self._requestServerData(timestamp)

        return ServerFetchResult.Success
    }
    
    // requests server data and process it
    private func _requestServerData(timestamp:Double) {
        var asyncCallback = ServerAsyncCallback(syncable: self._syncable,
            primaryKey: self._primaryKey,
            itemsCountKey: self._itemsCountKey,
            listKey: self._listKey,
            errorHandler: self._errorHandler)
        
        var session = SessionContext.createSessionFromCurrentSession()
        session?.callback = asyncCallback

        self._syncable.getServerData(timestamp, session: &session!)
    }
    
}
