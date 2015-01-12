//
//  Storyboards.swift
//  MobilePeopleDirectory
//
//  Created by Martin Zary on 1/11/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit

enum Storyboards {
    
    case Login
    case Settings
    case Main
    
    func Storyboard() -> UIStoryboard {
        switch self {
        case .Login:
            return UIStoryboard(name: "Login", bundle: NSBundle.mainBundle())
        case .Settings:
            return UIStoryboard(name: "Settings", bundle: NSBundle.mainBundle())
        case .Main:
            return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        }
        
    }
    
    
}