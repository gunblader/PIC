//
//  EditSetTableViewController.swift
//  project
//
//  Created by Erica Halpern on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import CoreData

class EditSetTableViewController: UITableViewController {
    
    var cards = [NSManagedObject]()
    var sets = [NSManagedObject]()

    let reuseIdentifier = "cardEditId"
    var setName =  ""
    var setId = -1
    var listItems = [EditSetListItem]()
    var newCard: Bool = false
    
    
    @IBOutlet weak var setNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationController?.setToolbarHidden(false, animated: false)
        self.title = "Edit Set"
        setNameTextField.text = setName
        getCards()
        
        // 1
        tableView.registerClass(EditSetTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getCards()
        listItems = [EditSetListItem]()
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
    
//    @IBAction func saveCardsBtn(sender: AnyObject) {
//        saveCards()
//        saveCardSet()
//        print("hi")
//        performSegueWithIdentifier("saveEditedSetSegue", sender: self)
//    }

    @IBAction func saveSetBtn(sender: AnyObject) {
              print("hi")
        saveCards()
        saveCardSet()
  
        performSegueWithIdentifier("saveEditedSetSegue", sender: self)
    }
    
    @IBAction func addCardBtn(sender: AnyObject) {
        let newCard = Card(front: String(), back: String(), id: cards.count, setId: setId)
        saveNewCard(newCard)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        if let destination = segue.destinationViewController as? SetTableViewController {
            destination.setName = setName
        }
        else if let destination = segue.destinationViewController as? AddCardViewController {
            destination.setName = setName
        }
        navigationController?.setToolbarHidden(true, animated: false)
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
        card.setValue(cards.count, forKey: "id")
        card.setValue(setId, forKey: "setId")
        
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
    
    
    func saveCardSet() {
        // Get set
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"CardSet")
        
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
            sets = results
        } else {
            print("Could not fetch")
        }
        
        // Update set
        print("new card sets: \(sets)")
        var cardSet = sets[0]
        
        // Set the attribute values
        cardSet.setValue(setNameTextField.text, forKey: "name")
        
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
    }
    
    func saveCards() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // Commit the changes.
        do {
            try managedContext.save()
        } catch {
            // what to do if an error occurs?
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
}
