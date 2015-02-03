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
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var skype: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var portrait: UIImageView!
    
    var imageHelper:ImageHelper = ImageHelper()
    
    var detailItem: Person?

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let nameLabel = self.Name {
                nameLabel.text = detail.valueForKey("fullName")!.description
            }
            if let emailLabel = self.email {
                emailLabel.text = detail.valueForKey("emailAddress")!.description
            }
            
            if let screenNameLabel = self.screenName {
                screenNameLabel.text = detail.valueForKey("screenName")!.description
            }
            
            if let phoneLabel = self.phone {
                phoneLabel.text = detail.valueForKey("userPhone")!.description
            }
            if let skypeLabel = self.skype {
                skypeLabel.text = detail.valueForKey("skypeName")!.description
            }
            
            let url = NSURL(string: LiferayServerContext.server + detail.valueForKey("portraitUrl")!.description)

            
            if imageHelper.hasUserImage(detail.valueForKey("portraitUrl")!.description) {
                imageHelper.addImageFromData(portrait, image: detail.portraitImage)
                imageHelper.addImageFromData(bgImage, image: detail.portraitImage)
            } else {
                portrait.image = UIImage(named: "UserDefaultImage")
                bgImage.image = UIImage(named: "UserDefaultImage")
            }
            
            imageHelper.addBlurStyles(bgImage)
            
            imageHelper.addThumbnailStyles(portrait, radius: 60.0)
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

