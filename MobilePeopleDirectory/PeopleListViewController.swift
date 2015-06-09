//
//  PeopleListViewController.swift
//  MobilePeopleDirectory
//
//  Created by Martin Zary on 1/6/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

import UIKit
import CoreData

class PeopleListViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive:Bool = false
    var searchResultsList: [Person] = []
    
    var personViewController: PersonViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var peopleDao:PeopleDao = PeopleDao()
    var imageHelper:ImageHelper = ImageHelper()
    var serverFetchResult : ServerFetchResult = ServerFetchResult.Success
    var alertHelper:AlertHelper = AlertHelper()
    var appHelper = AppHelper()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.personViewController = controllers[controllers.count-1].topViewController as? PersonViewController
        }
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        let logoutButton = UIBarButtonItem(image: UIImage(named: "logout"), style: UIBarButtonItemStyle.Plain, target: self, action: "logout:")
        self.navigationItem.rightBarButtonItem = logoutButton
        
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.hidesBarsWhenKeyboardAppears = true
        
        //search bar
        if let search = self.searchBar {
            self.searchBar.delegate = self
        }
    }
    
    func logout(sender:UIBarButtonItem) {
        self.alertHelper.confirmationMessage(self, title: "Please confirm", message: "Are you sure you want to logout?", okButtonText: "Yes", cancelButtonText: "No", confirmed: { _ in
            self.appHelper.logout(self)
        })
    }
    
    private func _showConnectionErrorMessage() {
        alertHelper.message(self,
            title: "Network",
            message: "There are connectivity issues please try again",
            buttonText: "OK",
            callback: {})
    }
    
    override func loadView() {
        if !SessionContext.loadSessionFromStore() {
            self.appHelper.logout(self)
        } else {
            super.loadView()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        var this = self
        var peopleSync = ServerSync(syncable: peopleDao,
            primaryKey: "userId",
            itemsCountKey: "activeUsersCount",
            listKey: "users",
            errorHandler: { error in
                if error == ServerFetchResult.ConnectivityIssue {
                    println("Connectivity issues")
                    self._showConnectionErrorMessage()
                }
            })
        serverFetchResult = peopleSync.syncData()
        self.searchActive = false
        self.searchResultsList = []
        if let table = self.tableView {
            self.tableView.reloadData()
        }
        if let search = self.searchBar {
            self.searchBar.text = ""
        }
        
        let appDelegate: AppDelegate = appHelper.getAppDelegate()
        appDelegate.statusBar.backgroundColor = navigationController?.navigationBar.backgroundColor
        
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        if serverFetchResult == .CredIssue {
            let loginViewController = Storyboards.Login.Storyboard().instantiateInitialViewController() as? LoginViewController
            self.parentViewController?.presentViewController(loginViewController!, animated: true, completion: nil)
        }
        if serverFetchResult == .ConnectivityIssue {
            //TODO:  Alert view informing the user of a network error and pointing the to the refresh button to try again
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
//        let context = self.fetchedResultsController.managedObjectContext
//        let entity = self.fetchedResultsController.fetchRequest.entity!
//        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context) as NSManagedObject
//             
//        // If appropriate, configure the new managed object.
//        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
//        newManagedObject.setValue(NSDate(), forKey: "timeStamp")
//             
//        // Save the context.
//        var error: NSError? = nil
//        if !context.save(&error) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            //println("Unresolved error \(error), \(error.userInfo)")
//            abort()
//        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                var person:Person
                
                if searchActive && self.searchResultsList.count > 0 {
                    person = searchResultsList[indexPath.row]
                } else {
                    person = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Person
                }
                
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! PersonViewController
                controller.detailItem = person
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchActive {
            return self.searchResultsList.count
        }
        let sectionInfo = self.fetchedResultsController.sections![section] as! NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PersonCell", forIndexPath: indexPath) as! PersonViewCell
        
        self.configureCell(cell, atIndexPath: indexPath)
        
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }
        else {
            cell.contentView.backgroundColor = UIColor(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
                
            var error: NSError? = nil
            if !context.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }

    func configureCell(cell: PersonViewCell, atIndexPath indexPath: NSIndexPath) {
        var person:Person
        
        if searchActive && self.searchResultsList.count > 0 {
            person = searchResultsList[indexPath.row]
        } else {
            person = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Person
        }

        imageHelper.addThumbnailStyles(cell.thumbnailImage, radius: 30.0)

        if imageHelper.hasUserImage(person.portraitUrl) {
            imageHelper.addImageFromData(cell.thumbnailImage, image: person.portraitImage)
        } else {
            cell.thumbnailImage.image = UIImage(named: "UserDefaultImage")
        }
        cell.username!.text = person.screenName
        cell.skypeIcon.hidden = (person.skypeName == "")
        cell.emailIcon.hidden = (person.emailAddress == "")
        cell.phoneIcon.hidden = (person.userPhone == "")
        cell.fullName!.text = person.fullName
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "fullName", ascending: true)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil
        )
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
    	var error: NSError? = nil
    	if !_fetchedResultsController!.performFetch(&error) {
    	     // Replace this implementation with code to handle the error appropriately.
    	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             //println("Unresolved error \(error), \(error.userInfo)")
    	     abort()
    	}
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController? = nil

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            default:
                return
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            //case .Update:
            //    self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)! as PersonViewCell, atIndexPath: indexPath!)
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            default:
                return
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */
    
    // MARK: - Search
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let searchString = searchText
        searchResultsList.removeAll(keepCapacity: true)
        
        if !searchString.isEmpty {
            let filter:Person -> Bool = { person in
                let nameLength = count(person.fullName)
                let fullNameRange = person.fullName.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch)
                let screenNameRange = person.screenName.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch)
                let emailAddress = person.emailAddress.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return fullNameRange != nil || screenNameRange != nil || emailAddress != nil
            }
            
            let sectionInfo = self.fetchedResultsController.sections![0] as! NSFetchedResultsSectionInfo
            let persons = sectionInfo.objects as! [Person]
            searchResultsList = persons.filter(filter)
        }
        
        if(searchResultsList.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.tableView.reloadData()
    }

    
    override func viewWillDisappear(animated: Bool) {
        
        //if searchBar.isFirstResponder() {
        //    searchBar.resignFirstResponder()
        //}
    }
}

