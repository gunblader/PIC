//
//  SetTableViewController.swift
//  project
//
//  Created by Erica Halpern on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import CoreData

class SetTableViewController: UITableViewController {
    
    var cards = [NSManagedObject]()
    var setName =  ""
    var setId =  -1
    var selectedSet:NSManagedObject? = nil
    var listOfCards = [Card]()

    let reuseIdentifier = "cardId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = setName
        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        getCards()
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func getCards() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Card")
        
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            fetchRequest.predicate = NSPredicate(format: "setId == %d", setId)
            try fetchedResults = managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        } catch {
            // what to do if an error occurs?
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        if let results = fetchedResults {
            cards = results
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
        return self.cards.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)

        // Get the data from Core Data
        let card = cards[indexPath.row]
        let front = "\(card.valueForKey("front") as! String)"
        let back = "\(card.valueForKey("back") as! String)"
        let selectedCard = Card(front: front, back: back, id: indexPath.row, setId: setId)
        listOfCards += [selectedCard]
        
        cell.textLabel!.text = front
        cell.detailTextLabel!.text = back
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        if let destination = segue.destinationViewController as? EditSetTableViewController {
            destination.setId = setId
            destination.setName = setName
            destination.set = selectedSet
            destination.listOfCards =  listOfCards
        }
        
        if let destination = segue.destinationViewController as? ReviewSetCollectionViewController {
            destination.setName = setName
            destination.cards = self.cards
        }
    }
    
    
}
