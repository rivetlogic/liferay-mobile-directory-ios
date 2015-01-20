//
//  AppHelper.swift
//  MobilePeopleDirectory
//
//  Created by alejandro soto on 1/16/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit

class AppHelper {
    
    func getAppDelegate() -> AppDelegate {
    	return UIApplication.sharedApplication().delegate as AppDelegate
    }
}
