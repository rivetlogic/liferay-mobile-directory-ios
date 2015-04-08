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
    
    func confirmationMessage(controller: UIViewController, title: String, message: String, okButtonText: String, cancelButtonText: String, confirmed: ((Void) -> Void)!)  {
        var alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okButtonAction = UIAlertAction(title: okButtonText, style: .Default, handler: { (alert: UIAlertAction!) in
            confirmed()
        })
        let cancelButtonAction = UIAlertAction(title: cancelButtonText, style: .Default, handler: nil)
        alert.addAction(okButtonAction)
        alert.addAction(cancelButtonAction)
        controller.presentViewController(alert, animated: true, completion: nil)
    }

}
