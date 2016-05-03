//
//  EditSetTableViewController.swift
//  project
//
//  Created by Erica Halpern on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import CoreData

class EditSetTableViewController: UITableViewController, UITextFieldDelegate{
    
    var cards = [NSManagedObject]()
    var testing = "nope"
    let reuseIdentifier = "cardEditId"
    var setName =  ""
    var setId = -1
    var set:NSManagedObject? = nil
    var listOfCards = [Card]()
    let idCounter = NSUserDefaults.standardUserDefaults()
    var imgToSave:UIImage = UIImage()
    var returningFromDraw:Bool = false
    var drawFront = true
    var cardToDraw:Card = Card()
    var editDrawing = false
    
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
        self.tableView.rowHeight = 100.0

        setNameTextField.text = setName
        tableView.alwaysBounceVertical = false
        attatchKeyboardToolbar(setNameTextField)
        setNameTextField.delegate = self
        tableView.registerClass(EditSetTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        getCards()

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath)
        print("here")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EditSetTableViewCell
        let card = listOfCards[indexPath.row]
        cell.listItems = card
        cell.selectionStyle = UITableViewCellSelectionStyle.Blue

        attatchKeyboardToolbar(cell.front)
        attatchKeyboardToolbar(cell.back)
        
        cell.card = card
        cell.nsindex = indexPath
        cell.tableView = self
        
        drawFront = cell.drawFront
        print(drawFront)
        if(card.newCard) {
            cell.front.becomeFirstResponder()
            cell.front.accessibilityLabel = "\(indexPath.row)"
        }
        
//        if(cell.frontIsImg) {
//            cell.frontImgView!.userInteractionEnabled = true
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: "editCard:")
//            cell.frontImgView!.addGestureRecognizer(tapRecognizer)
//        }

        return cell
    }
    
    func attatchKeyboardToolbar(textField : UITextField) {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let addCard = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditSetTableViewController.addCardBtn(_:)))
        let font = UIFont(name: "Helvetica", size: 35)
        addCard.setTitleTextAttributes([NSFontAttributeName: font!], forState: UIControlState.Normal)
        addCard.tintColor = UIColor(colorLiteralRed: 228/255, green: 86/255, blue: 99/255, alpha: 1)
        
        let drawCard = UIBarButtonItem(title: "Draw", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditSetTableViewController.drawCardBtn(_:)))
        drawCard.setTitleTextAttributes([NSFontAttributeName: font!], forState: UIControlState.Normal)
        drawCard.tintColor = UIColor(colorLiteralRed: 228/255, green: 86/255, blue: 99/255, alpha: 1)
        toolbar.items = [flexSpace, addCard, flexSpace, drawCard]
        textField.inputAccessoryView = toolbar
    }
    
    @IBAction func addCardBtn(sender: AnyObject) {
        let cardId = (idCounter.objectForKey("numCards") as? Int)!
        let createdCard = Card(front: String(), back: String(), frontIsImg: false, backIsImg: false, frontImg: UIImage(), backImg: UIImage(), id: cardId, setId: setId, edited: false, newCard: true, drawFront: true)
        idCounter.setObject(cardId + 1, forKey: "numCards")

        createdCard.newCard = true
        listOfCards.append(createdCard)
        tableView.reloadData()
    }
    
    @IBAction func drawCardBtn(sender: AnyObject) {
        performSegueWithIdentifier("editToDrawSegue", sender: nil)
    }
    
    func editCard(theCard: Card) {
        editDrawing = true
        cardToDraw = theCard
        performSegueWithIdentifier("editToDrawSegue", sender: nil)
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
                            card.setValue(cardToSave.frontIsImg, forKey: "frontIsImg")
                            card.setValue(UIImageJPEGRepresentation(cardToSave.frontImg, 0), forKey: "frontImg")
                            card.setValue(cardToSave.backIsImg, forKey: "backIsImg")
                            card.setValue(UIImageJPEGRepresentation(cardToSave.backImg, 0), forKey: "backImg")
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
                card.setValue(cardToSave.frontIsImg, forKey: "frontIsImg")
                card.setValue(cardToSave.backIsImg, forKey: "backIsImg")
                card.setValue(UIImageJPEGRepresentation(cardToSave.frontImg, 0), forKey: "frontImg")
                card.setValue(UIImageJPEGRepresentation(cardToSave.backImg, 0), forKey: "backImg")
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
        
        if let destination = segue.destinationViewController as? DrawViewController {
            destination.setId = setId
            destination.setName = setName
            destination.listOfCards = listOfCards
            if (editDrawing) {
                destination.card = cardToDraw
            } else {
                destination.card = listOfCards[(self.tableView?.indexPathForSelectedRow!.row)!]
            }
            print(drawFront)
            destination.drawFront = listOfCards[(self.tableView?.indexPathForSelectedRow!.row)!].drawFront
        }
        
        navigationController?.setToolbarHidden(true, animated: false)
    }
}
