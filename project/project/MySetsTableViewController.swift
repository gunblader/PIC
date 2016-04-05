//
//  MySetsTableViewController.swift
//  project
//
//  Created by Erica Halpern on 3/21/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import CoreData

class MySetsTableViewController: UITableViewController {

    var sets = [NSManagedObject]()
    let reuseIdentifier = "setId"
    var cardSets = [CardSet]()

    @IBOutlet var mySetsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCardSets()
        navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        // #warning Incomplete implementation, return the number of rows
        return self.sets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        // Get the data from Core Data
        let set = sets[indexPath.row]
        let name = "\(set.valueForKey("name") as! String)"
        let date = "\(set.valueForKey("date") as! String)"
        cell.textLabel!.text = name
        cell.detailTextLabel!.text = date
        
        return cell
    }

      
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? SetTableViewController {
            let setId:Int = self.tableView!.indexPathForSelectedRow!.row
            destination.setId = setId
            destination.setName = sets[setId].valueForKey("name") as! String
            destination.selectedSet = sets[setId]
        }
        if let destination = segue.destinationViewController as? NewSetTableViewController {
            destination.setId = sets.count
        }
    }


}
