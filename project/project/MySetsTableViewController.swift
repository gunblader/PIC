//
//  MySetsTableViewController.swift
//  project
//
//  Created by Erica Halpern on 3/21/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import CoreData

class MySetsTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    var sets = [NSManagedObject]()
    let reuseIdentifier = "setId"
    var cardSets = [CardSet]()
    
    var setsSearchResults:Array<CardSet>?
    var searchController:UISearchController!
    
    @IBOutlet var mySetsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCardSets()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.setToolbarHidden(true, animated: false)

        self.searchController = UISearchController(searchResultsController: nil)
        let pink = UIColor(red:0.92, green:0.43, blue:0.46, alpha:1.0)
        
        searchController.searchBar.tintColor = pink
        searchController.searchBar.layer.backgroundColor = UIColor(red: 0.6275, green: 0.6275, blue: 0.6275, alpha: 1.0).CGColor
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        mySetsTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["All Sets", "My Sets"]
        mySetsTableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func filterContentForSearchText(searchText: String, scope: Int) {
        setsSearchResults = cardSets.filter({ (aSet:CardSet) -> Bool in
            var fieldToSearch: String?
            switch (scope) {
            case (0):
                fieldToSearch = "All Sets"
            case (1):
                fieldToSearch = "My Sets"
            default:
                fieldToSearch = "My Sets"
            }
            // Add advanced sets to the search here
            if fieldToSearch == nil {
                self.setsSearchResults = nil
                return false
            }
            let nameMatch = aSet.name.rangeOfString(searchText, options:NSStringCompareOptions.CaseInsensitiveSearch)
            return nameMatch != nil
        })
        if searchText == "" {
            setsSearchResults = cardSets
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let selectedIndex = searchController.searchBar.selectedScopeButtonIndex
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText, scope: selectedIndex)
            mySetsTableView.reloadData()
        }
    }
    
    
    func loadSets() {
        cardSets = []
        
        for set in sets {
            print(set.valueForKey("name") as! String)
            print(set.valueForKey("date") as! String)
            cardSets.append(CardSet(name: set.valueForKey("name") as! String, date: set.valueForKey("date") as! String, id: set.valueForKey("id") as! Int))
        }
    }
    
    func getCardSets() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"CardSet")
        
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        } catch {
            // what to do if an error occurs?
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        if let results = fetchedResults {
            sets = results
        } else {
            print("Could not fetch")
        }
        
        //Put Sets into Array for easy handling
        loadSets()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return setsSearchResults!.count
        } else {
            return self.sets.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = mySetsTableView!.dequeueReusableCellWithIdentifier(reuseIdentifier)
        
        if searchController.active {
            let set = setsSearchResults![indexPath.row]
            cell!.textLabel!.text = set.name
            cell!.detailTextLabel!.text = set.date
        } else {
            // Get the data from Core Data
            let set = sets[indexPath.row]
            
            let name = "\(set.valueForKey("name") as! String)"
            let date = "\(set.valueForKey("date") as! String)"
            cell!.textLabel!.text = name
            cell!.detailTextLabel!.text = date
        }
        
        return cell!
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? SetTableViewController {
            if searchController.active {
                let set = setsSearchResults![self.tableView!.indexPathForSelectedRow!.row]
                let setId:Int = set.id
                destination.setId = setId
                destination.setName = sets[setId].valueForKey("name") as! String
                destination.selectedSet = sets[setId]
                searchController.dismissViewControllerAnimated(true, completion: nil)
            } else {
                let setId:Int = self.tableView!.indexPathForSelectedRow!.row
                destination.setId = setId
                destination.setName = sets[setId].valueForKey("name") as! String
                destination.selectedSet = sets[setId]
            }
        }
        if let destination = segue.destinationViewController as? NewSetTableViewController {
            destination.setId = sets.count
            destination.sets = sets
        }
    }
    
    
}