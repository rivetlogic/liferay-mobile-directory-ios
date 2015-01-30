//
//  PersonViewController.swift
//  MobilePeopleDirectory
//
//  Created by Martin Zary on 1/6/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var skype: UILabel!
    @IBOutlet weak var portrait: UIImageView!
    
    var imageHelper:ImageHelper = ImageHelper()
    
    var detailItem: Person? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let nameLabel = self.Name {
                nameLabel.text = detail.valueForKey("fullName")!.description
            }
            if let emailLabel = self.email {
                emailLabel.text = detail.valueForKey("emailAddress")!.description
            }
            if let jobTitleLabel = self.jobTitle {
                jobTitleLabel.text = detail.valueForKey("jobTitle")!.description
            }
            if let screenNameLabel = self.screenName {
                screenNameLabel.text = detail.valueForKey("screenName")!.description
            }
            if let cityLabel = self.city {
                cityLabel.text = detail.valueForKey("city")!.description
            }
            if let phoneLabel = self.phone {
                phoneLabel.text = detail.valueForKey("userPhone")!.description
            }
            if let skypeLabel = self.skype {
                skypeLabel.text = detail.valueForKey("skypeName")!.description
            }
            
            let url = NSURL(string: LiferayServerContext.server + detail.valueForKey("portraitUrl")!.description)
            imageHelper.addImageFromData(portrait, image: detail.portraitImage)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelPresssed(sender: AnyObject) {
        
    }

}

