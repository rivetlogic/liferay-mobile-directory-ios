//
//  LoginViewController.swift
//  MobilePeopleDirectory
//
//  Created by Martin Zary on 1/11/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginScreenletDelegate {

    @IBOutlet weak var loginScreenlet: LoginScreenlet!
    
    var appHelper = AppHelper()
    var alertHelper = AlertHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginScreenlet!.delegate = self
        loginScreenlet!.authMethod = AuthMethod.Email.rawValue
        loginScreenlet!.saveCredentials = true
        
        // bg gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.frame
        gradientLayer.colors = [UIColor(red: 234/255.0, green: 233/255.0, blue: 235/255.0, alpha: 1.0).CGColor, UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0).CGColor]
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Liferay Login Screenlet delegate
    
    func onLoginResponse(attributes: [String : AnyObject]) {
        println("onLoginResponse attributes:", attributes)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onLoginError(error: NSError) {
        println(error)
        // handled failed login using passed error
    }
    
    func onCredentialsLoaded(session:LRSession) {
        print("Saved loaded for server " + session.server)
    }
    
    func onCredentialsSaved(session:LRSession) {
        print("Saved credentials for server " + session.server)
    }
    
    @IBAction func forgotPasswordPressed(sender: AnyObject) {
        let forgotPasswordVC = Storyboards.Login.Storyboard().instantiateViewControllerWithIdentifier("forgotPasswordView") as? ForgotPasswordViewController
        presentViewController(forgotPasswordVC!, animated: true, completion: nil)
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
