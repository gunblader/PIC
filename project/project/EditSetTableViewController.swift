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

    let reuseIdentifier = "cardEditId"
    var setName =  ""
    var setId = -1
    var listItems = [EditSetListItem]()
    var newCard: Bool = false
    var set:NSManagedObject? = nil
    var listOfCards = [Card]()
    
    @IBOutlet weak var setNameTextField: UITextField!
    
//    @IBAction func saveBtn(sender: AnyObject) {
//        saveNewCards()
//        
//        performSegueWithIdentifier("saveEditedSetSegue", sender: self)
//        
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.title = "Edit Set"
        setNameTextField.text = setName
        
        // 1
        tableView.registerClass(EditSetTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        getCards()
//        listItems = [EditSetListItem]()
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
        return listOfCards.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EditSetTableViewCell
        
        let card = listOfCards[indexPath.row]
        cell.listItems = card
        cell.selectionStyle = UITableViewCellSelectionStyle.None
    
        if(card.newCard) {
            cell.front.becomeFirstResponder()
        }
        
        return cell
    }
    
    @IBAction func addCardBtn(sender: AnyObject) {
        let createdCard = Card(front: String(), back: String(), id: listOfCards.count, setId: setId, edited: false, newCard: true)
        createdCard.newCard = true
        listOfCards.append(createdCard)
        tableView.reloadData()
    }
    
    func saveNewCards() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        for cardToSave in listOfCards {
            if(cardToSave.front == "" && cardToSave.back == "") {
                if(!cardToSave.newCard) {
                    managedContext.deleteObject(cards[cardToSave.id])
                }
            } else if (cardToSave.newCard) {
                // Create the entity we want to save
                let entity =  NSEntityDescription.entityForName("Card", inManagedObjectContext: managedContext)
                
                let card = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
                print("New \(cardToSave.id) \(cardToSave.back)")
                card.setValue(cardToSave.front, forKey: "front")
                card.setValue(cardToSave.back, forKey: "back")
                card.setValue(cardToSave.id, forKey: "id")
                card.setValue(cardToSave.setId, forKey: "setId")
                cardToSave.edited = false
                cardToSave.newCard = false
            } else if (cardToSave.edited) {
                let card = cards[cardToSave.id]
                print("Edited \(cardToSave.id) \(cardToSave.back)")
                card.setValue(cardToSave.front, forKey: "front")
                card.setValue(cardToSave.back, forKey: "back")
                cardToSave.edited = false
            }

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
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? SetTableViewController {
            destination.setName = setNameTextField.text!
            destination.setId = setId
            destination.listOfCards = listOfCards
            self.view.endEditing(true)
            saveNewCards()
        }
        else if let destination = segue.destinationViewController as? AddCardViewController {
            destination.setName = setNameTextField.text!
        }
        navigationController?.setToolbarHidden(true, animated: false)
    }
}
