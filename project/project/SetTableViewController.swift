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
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        getCards()
        listOfCards = [Card]()
        tableView.registerClass(SetTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.rowHeight = 100.0

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
        return cards.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SetTableViewCell
        
        // Get the data from Core Data
        let card = cards[indexPath.row]
        let front = "\(card.valueForKey("front") as! String)"
        let back = "\(card.valueForKey("back") as! String)"
        let frontIsImg = card.valueForKey("frontIsImg") as! Bool
        let backIsImg = card.valueForKey("backIsImg") as! Bool
        var frontImg = UIImage()
        var backImg = UIImage()
        
        
        if(frontIsImg) {
            frontImg = UIImage(data: card.valueForKey("frontImg") as! NSData)!
            cell.frontImgView!.image = frontImg
            
        } else {
            cell.front!.text = front
        }
        
        if(backIsImg) {
            backImg = UIImage(data: card.valueForKey("backImg") as! NSData)!
            cell.backImgView!.image = backImg
        } else {
            cell.back!.text = back
        }

        let id = card.valueForKey("id") as! Int

        let selectedCard = Card(front: front, back: back, frontIsImg: frontIsImg, backIsImg: backIsImg, frontImg: frontImg, backImg: backImg, id: id, setId: setId, edited: false, newCard: false, drawFront: true)
        cell.listItems = selectedCard
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.card = selectedCard

        listOfCards += [selectedCard]

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
            destination.listOfCards = listOfCards
        }
        
        if let destination = segue.destinationViewController as? ReviewSetCollectionViewController {
            destination.setName = setName
            destination.cards = self.cards
        }
        
        if let destination = segue.destinationViewController as? PracticeController {
            destination.setName = setName
            destination.cards = listOfCards
        }
        
        if let destination = segue.destinationViewController as? TestSetCollectionViewController {
            destination.setName = setName
            destination.cards = self.listOfCards
            
            destination.setId = setId
            destination.selectedSet = selectedSet
        }
    }
    
    
}
