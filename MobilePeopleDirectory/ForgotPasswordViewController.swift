//
//  ForgotPasswordViewController.swift
//  MobilePeopleDirectory
//
//  Created by alejandro soto on 1/15/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, ForgotPasswordScreenletDelegate {
    @IBOutlet weak var forgotPasswordScreenlet: ForgotPasswordScreenlet!
	
    var appHelper = AppHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		forgotPasswordScreenlet!.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onForgotPasswordResponse(newPasswordSent:Bool) {
        print(newPasswordSent)
        dismissViewControllerAnimated(true, completion: nil)
    }
    func onForgotPasswordError(error: NSError) {
        print(error)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
