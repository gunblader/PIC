//
//  NewSetTableViewController.swift
//  project
//
//  Created by Erica Halpern on 3/31/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import CoreData

class NewSetTableViewController: UITableViewController {
    var newCardSet:CardSet = CardSet(name: "start", date: "0", id: 0)
    
    var sets = [NSManagedObject]()
    
    var cards = [NSManagedObject]()
    let reuseIdentifier = "newCardEditId"
    var setName =  ""
    var listItems = [EditSetListItem]()
    var newCard: Bool = false
    var setId = -1
    
    @IBOutlet weak var cardSetName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationController?.setToolbarHidden(false, animated: false)
        self.title = "New Set"
        
        tableView.registerClass(EditSetTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        getCards()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getCards()
        listItems = [EditSetListItem]()
    }
    
    @IBAction func addCardBtn(sender: AnyObject) {
        let newCard = Card(front: String(), back: String(), id: cards.count, setId: setId)
        saveNewCard(newCard)
    }
    
    func saveNewCard(cardToSave:Card) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // Create the entity we want to save
        let entity =  NSEntityDescription.entityForName("Card", inManagedObjectContext: managedContext)
        
        let card = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        // Set the attribute values
        card.setValue(cardToSave.front, forKey: "front")
        card.setValue(cardToSave.back, forKey: "back")
        card.setValue(cards.count - 1, forKey: "id")
        card.setValue(cardToSave.setId, forKey: "setId")

        // Commit the changes.
        do {
            try managedContext.save()
        } catch {
            // what to do if an error occurs?
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        // Add the new entity to our array of managed objects
        cards.append(card)
        listItems += [EditSetListItem(front: cardToSave.front, back: cardToSave.back, id: cardToSave.id, card: card, newCard: true)]
        newCard = true
        tableView?.reloadData()
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
    
    @IBAction func saveNewCardSetBtn(sender: AnyObject) {
        newCardSet.name = cardSetName.text!
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        newCardSet.date = dateFormatter.stringFromDate(date)
        newCardSet.id = setId
        print("new card set id: \(newCardSet.id)")
        saveCardSet(newCardSet)
        performSegueWithIdentifier("newSetSegue", sender: self)
    }
    
    func saveCardSet(cardSetToSave:CardSet) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // Create the entity we want to save
        let entity =  NSEntityDescription.entityForName("CardSet", inManagedObjectContext: managedContext)
        
        let cardSet = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        // Set the attribute values
        cardSet.setValue(cardSetToSave.name, forKey: "name")
        cardSet.setValue(cardSetToSave.date, forKey: "date")
        cardSet.setValue(cardSetToSave.id, forKey: "id")

        // Commit the changes.
        do {
            try managedContext.save()
        } catch {
            // what to do if an error occurs?
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        // Add the new entity to our array of managed objects
        sets.append(cardSet)
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
        // Get the data from Core Data
        let card = cards[indexPath.row]
        let front = "\(card.valueForKey("front") as! String)"
        let back = "\(card.valueForKey("back") as! String)"
        let id = card.valueForKey("id") as! Int
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EditSetTableViewCell
        
        listItems += [EditSetListItem(front: front, back: back, id: id, card: card, newCard: false)]
        
        // Configure the cell...
        let item = listItems[indexPath.row]
        cell.listItems = item
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if(newCard && (indexPath.row == cards.count - 1)) {
            cell.front.becomeFirstResponder()
            newCard = false
        }
        
        return cell
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
