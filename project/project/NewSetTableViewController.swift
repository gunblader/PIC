//
//  NewSetTableViewController.swift
//  project
//
//  Created by Erica Halpern on 3/31/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import CoreData

class NewSetTableViewController: UITableViewController, UITextFieldDelegate {
    var newCardSet:CardSet = CardSet(name: "start", date: "0", id: 0)
    
    var sets = [NSManagedObject]()
    
    var cards = [NSManagedObject]()
    let reuseIdentifier = "newCardEditId"
    var setName =  ""
    var listItems = [NewSetListItem]()
    var newCard: Bool = false
    var setId = -1
    
    var cardsToSave = [Card]()
    
    @IBOutlet weak var cardSetName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        navigationController?.setToolbarHidden(false, animated: false)
        self.title = "New Set"
        
        tableView.registerClass(NewSetTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.cardSetName.delegate = self;
    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
    }
    
    @IBAction func addCardBtn(sender: AnyObject) {
        let createdCard = Card(front: String(), back: String(), id: cardsToSave.count, setId: setId, edited: false, newCard: true)
        print("\(createdCard.id)")
        
        cardsToSave.append(createdCard)
        tableView.reloadData()
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
         saveCards()
        performSegueWithIdentifier("newSetSegue", sender: self)
    }
    
    func saveCards() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        for cardToSave in cardsToSave {
            print(cardToSave.id)
            
            // Create the entity we want to save
            let entity =  NSEntityDescription.entityForName("Card", inManagedObjectContext: managedContext)
            
            let card = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
            
            card.setValue(cardToSave.front, forKey: "front")
            card.setValue(cardToSave.back, forKey: "back")
            card.setValue(cardToSave.id, forKey: "id")
            card.setValue(cardToSave.setId, forKey: "setId")
        }
        
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
        //        sets.append(cardSet)
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
        return cardsToSave.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewSetTableViewCell
        
        // Get the data from Core Data
        let card = cardsToSave[indexPath.row]

        cell.listItems = card
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if(newCard && (indexPath.row == cards.count - 1)) {
            
            cell.front.becomeFirstResponder()
            newCard = false
        }

        return cell
    }


    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
