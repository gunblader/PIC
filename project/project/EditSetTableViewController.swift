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
    let idCounter = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var setNameTextField: UITextField!
    
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
        tableView.alwaysBounceVertical = false
        // 1
        tableView.registerClass(EditSetTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        getCards()

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
        attatchKeyboardToolbar(cell.front)
        attatchKeyboardToolbar(cell.back)
    
        if(card.newCard) {
            cell.front.becomeFirstResponder()
        }
        
        return cell
    }
    
    func attatchKeyboardToolbar(textField : UITextField) {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let addCard = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.Plain, target: self, action: "addCardBtn:")
        let font = UIFont(name: "Helvetica", size: 35)
        addCard.setTitleTextAttributes([NSFontAttributeName: font!], forState: UIControlState.Normal)
        addCard.tintColor = UIColor(colorLiteralRed: 228/255, green: 86/255, blue: 99/255, alpha: 1)
        toolbar.items = [flexSpace, addCard, flexSpace]
        textField.inputAccessoryView = toolbar
    }
    
    @IBAction func addCardBtn(sender: AnyObject) {
        let cardId = (idCounter.objectForKey("numCards") as? Int)!
        let createdCard = Card(front: String(), back: String(), id: cardId, setId: setId, edited: false, newCard: true)
        idCounter.setObject(cardId + 1, forKey: "numCards")

        createdCard.newCard = true
        listOfCards.append(createdCard)
        tableView.reloadData()
    }
    
    func saveNewCards() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Card")
        
        var fetchedResults:[NSManagedObject]? = nil
        
        for cardToSave in listOfCards {
            // print("Card: \(cardToSave.id) Front: \(cardToSave.front) Back: \(cardToSave.back) SetId: \(cardToSave.setId) New?: \(cardToSave.newCard)")
            if (cardToSave.edited && !cardToSave.newCard) {
                
                do {
                    fetchRequest.predicate = NSPredicate(format: "id == %d AND setId == %d", cardToSave.id, setId)
                    try fetchedResults = managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
                } catch {
                    // what to do if an error occurs?
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
                
                if let results = fetchedResults {
                    if(results.count > 0) {
                        let card = results[0]
                        
                        // Save or delete card
                        if(cardToSave.front == "" && cardToSave.back == "") {
                            managedContext.deleteObject(card)
                        } else {
                            card.setValue(cardToSave.front, forKey: "front")
                            card.setValue(cardToSave.back, forKey: "back")
                            cardToSave.edited = false
                        }
                    }
                } else {
                    print("Could not fetch")
                }
            } else if (cardToSave.newCard && !(cardToSave.front == "" && cardToSave.back == "")) {
                // Create the entity we want to save
                let entity =  NSEntityDescription.entityForName("Card", inManagedObjectContext: managedContext)
                
                let card = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
                card.setValue(cardToSave.front, forKey: "front")
                card.setValue(cardToSave.back, forKey: "back")
                card.setValue(cardToSave.id, forKey: "id")
                card.setValue(cardToSave.setId, forKey: "setId")
                cardToSave.edited = false
                cardToSave.newCard = false
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
            self.view.endEditing(true)
            
            saveNewCards()
        }
        else if let destination = segue.destinationViewController as? AddCardViewController {
            destination.setName = setNameTextField.text!
        }
        navigationController?.setToolbarHidden(true, animated: false)
    }
}
