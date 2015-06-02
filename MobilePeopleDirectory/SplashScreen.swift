//
//  SplashScreen.swift
//  MobilePeopleDirectory
//
//  Created by Rahul Chandera on 6/1/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit

class SplashScreen: UIViewController {

    var spiralView: SpiralView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        spiralView = SpiralView(frame:UIScreen.mainScreen().bounds)
        self.view.addSubview(spiralView!)
        spiralView?.startAnimation()
        self.view.bringSubviewToFront(spiralView!)
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("closeScreen"), userInfo: nil, repeats: false)

    }

    func closeScreen() {
        
        UIView.beginAnimations("Animation", context: nil)
        UIView.setAnimationDuration(2.0)
        self.view.alpha = 0.0
        UIView.commitAnimations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
