//
//  AlertHelper.swift
//  MobilePeopleDirectory
//
//  Created by alejandro soto on 1/16/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit

class AlertHelper {

    func message(controller: UIViewController, title: String, message: String, buttonText: String, callback: (Void) -> Void)  {
        var alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let buttonAction = UIAlertAction(title: buttonText, style: .Default) { (action: UIAlertAction!) -> Void in
        	callback()
        }
        alert.addAction(buttonAction)
        controller.presentViewController(alert, animated: true, completion: nil)
    }
}
