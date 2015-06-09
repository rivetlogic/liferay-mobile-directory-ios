//
//  PersonViewController.swift
//  MobilePeopleDirectory
//
//  Created by Martin Zary on 1/6/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit

class PersonViewController: UITableViewController, UIScrollViewDelegate {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var portrait: UIImageView!
    
    var imageHelper:ImageHelper = ImageHelper()
    var appHelper = AppHelper()
    var detailItem: Person?
    var alertHelper = AlertHelper()
    var headerView: UIView!
    private let kTableHeaderHeight: CGFloat = 275.0
    
    var skypeId: String!
    var emailId: String!
    var phoneNo: String!
    var detailsArray = []
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            
            if let nameLabel = self.name {
                nameLabel.text = detail.valueForKey("fullName")!.description
            }
            if let cityLabel = self.city {
                cityLabel.text = detail.valueForKey("city")!.description
            }
            if let nameLabel = self.jobTitle {
                nameLabel.text = detail.valueForKey("jobTitle")!.description
            }
            if let screenNameLabel = self.screenName {
                screenNameLabel.text = detail.valueForKey("screenName")!.description
            }
            
            skypeId = detail.valueForKey("skypeName")!.description
            emailId = detail.valueForKey("emailAddress")!.description
            phoneNo = detail.valueForKey("userPhone")!.description
            
            let url = NSURL(string: LiferayServerContext.server + detail.valueForKey("portraitUrl")!.description)
            
            if imageHelper.hasUserImage(detail.valueForKey("portraitUrl")!.description) {
                imageHelper.addImageFromData(portrait, image: detail.portraitImage)
                imageHelper.addImageFromData(bgImage, image: detail.portraitImage)
            } else {
                portrait.image = UIImage(named: "UserDefaultImage")
                bgImage.image = UIImage(named: "UserDefaultImage")
            }
            
            bgImage.image = imageHelper.convertImageToGrayScale(bgImage.image!)
            imageHelper.addThumbnailStyles(portrait, radius: 60.0)
            imageHelper.addBlurStyles(bgImage)
        }
        
        let skype = ["title":"Skype", "value":skypeId, "icon":"skype"]
        let email = ["title":"Email", "value":emailId, "icon":"mail"]
        let phone = ["title":"Phone", "value":phoneNo, "icon":"call"]
        
        detailsArray = [skype,email,phone]
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        self.navigationController?.navigationBarHidden = true
        
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateHeaderView()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let appDelegate: AppDelegate = appHelper.getAppDelegate()
        appDelegate.statusBar.backgroundColor = UIColor.clearColor()
    }
    
    
    func updateHeaderView() {
        
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
    
    
    
    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsArray.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonDetailCell", forIndexPath: indexPath) as! UITableViewCell
        
        let lblTitel: UILabel = cell.contentView.viewWithTag(102) as! UILabel
        let lblValue: UILabel = cell.contentView.viewWithTag(103) as! UILabel
        let imgIcon: UIImageView = cell.contentView.viewWithTag(101) as! UIImageView
        
        let cellData = detailsArray.objectAtIndex(indexPath.row) as! NSDictionary
        lblTitel.text = cellData["title"] as? String
        lblValue.text = cellData["value"] as? String
        imgIcon.image = UIImage(named:(cellData["icon"] as! String))
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        }
        else {
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cellData = detailsArray.objectAtIndex(indexPath.row) as! NSDictionary
        let value: String = cellData["value"] as! String
        let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
        
        switch indexPath.row
        {
        case 0:
            if value.stringByTrimmingCharactersInSet(whitespaceSet) != "" {
                UIApplication.sharedApplication().openURL(NSURL(string: "skype://" + value + "?call")!)
            }
            break;
        case 1:
            if value.stringByTrimmingCharactersInSet(whitespaceSet) != "" {
                UIApplication.sharedApplication().openURL(NSURL(string: "mailto:" + value)!)
            }
            break;
        case 2:
            if value.stringByTrimmingCharactersInSet(whitespaceSet) != "" {
                UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + value)!)
            }
            break;
            
        default:
            break;
        }
    }
    
    
    
    //MARK: - ScrollView Delegate
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    
    func logout(sender:UIBarButtonItem) {
        self.alertHelper.confirmationMessage(self, title: "Please confirm", message: "Are you sure you want to logout?", okButtonText: "Yes", cancelButtonText: "No", confirmed: { _ in
            self.appHelper.logout(self)
        })
    }
    
    
    @IBAction func backButtonTap(sender: AnyObject) {
        
        self.parentViewController?.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancelPresssed(sender: AnyObject) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

