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
    
    @objc var PrimaryColor = UIColor(red: 245/255.0, green: 130/255.0, blue: 32/255.0, alpha: 1.0)
    @objc var PrimaryColorTransparent = UIColor(red: 245/255.0, green: 130/255.0, blue: 32/255.0, alpha: 0.7)
    
    @objc var SecondaryColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    @objc var TopGradientColor = UIColor(red: 234/255.0, green: 233/255.0, blue: 235/255.0, alpha: 1.0)
    @objc var BottomGradientColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    
    private init() {
        
    }

    class var sharedInstance : MDPAppearance {
        struct Static {
            static let instance : MDPAppearance = MDPAppearance()
        }
        return Static.instance
    }
    
    
    class func setUpDefaultUiAppearances() {
        setupNavBarAppearance()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
    }
    
    private class func setupNavBarAppearance() {
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = sharedInstance.SecondaryColor
        appearance.barTintColor = sharedInstance.PrimaryColor
        appearance.backgroundColor = sharedInstance.PrimaryColor
    }
}
