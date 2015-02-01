//
//  ServerSyncable.swift
//  MobilePeopleDirectory
//
//  Created by alejandro soto on 2/1/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import Foundation

protocol ServerSyncable {

    class func getLastModifiedDate() -> NSDate
    
}