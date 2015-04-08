//
//  MDPAppearance.swift
//  MobilePeopleDirectory
//
//  Created by alejandro soto on 4/7/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit
import MessageUI

@objc class MDPAppearance {
    
    private init() {
        
    }

    class var sharedInstance : MDPAppearance {
        struct Static {
            static let instance : MDPAppearance = MDPAppearance()
        }
        return Static.instance
    }
    
    @objc var PrimaryColor = UIColor(red: 245/255.0, green: 130/255.0, blue: 32/255.0, alpha: 1.0)
    @objc var PrimaryColorTransparent = UIColor(red: 245/255.0, green: 130/255.0, blue: 32/255.0, alpha: 0.7)
}
