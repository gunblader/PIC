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
    var setId = -1
    var listOfCards = [Card]()
    var editDrawing = false
    var drawFront = true
    var cardToDraw:Card = Card()
    var imgToSave:UIImage = UIImage()
    var returningFromDraw:Bool = false

    let idCounter = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var cardSetName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.title = "New Set"
        self.editDrawing = false
        self.cardSetName.delegate = self;
        self.cardSetName.text = setName
        
        cardSetName.delegate = self
        setId = idCounter.integerForKey("numSets")
        self.tableView.rowHeight = 100.0

        tableView.alwaysBounceVertical = false
        tableView.registerClass(NewSetTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        attatchKeyboardToolbarName(cardSetName)
    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addCardBtn(sender: AnyObject) {
        let cardId = (idCounter.objectForKey("numCards") as? Int)!

        let createdCard = Card(front: String(), back: String(), frontIsImg: false, backIsImg: false, frontImg: UIImage(), backImg: UIImage(), id: cardId, setId: setId, edited: false, newCard: true, drawFront: true)
        print("hi \(createdCard.front)")
        idCounter.setObject(cardId + 1, forKey: "numCards")
        createdCard.newCard = true
        listOfCards.append(createdCard)
        tableView.reloadData()
    }
    
    func saveCardsSegue() {
        self.view.endEditing(true)

        newCardSet.name = cardSetName.text!
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        newCardSet.date = dateFormatter.stringFromDate(date)
        newCardSet.id = (idCounter.objectForKey("numSets") as? Int)! //crashed on making a set
        idCounter.setObject(setId + 1, forKey: "numSets")
        
        saveCardSet(newCardSet)
        saveCards()
    }
    
    func saveCards() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        for cardToSave in listOfCards {
            if((cardToSave.front == "" && cardToSave.back == "") && (!cardToSave.frontIsImg && !cardToSave.backIsImg)) {
                if(!cardToSave.newCard) {
                    managedContext.deleteObject(cards[cardToSave.id])
                }
            } else if (cardToSave.newCard) {
                // Create the entity we want to save
                let entity =  NSEntityDescription.entityForName("Card", inManagedObjectContext: managedContext)
                
                let card = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
                card.setValue(cardToSave.front, forKey: "front")
                card.setValue(cardToSave.back, forKey: "back")
                card.setValue(cardToSave.frontIsImg, forKey: "frontIsImg")
                card.setValue(cardToSave.backIsImg, forKey: "backIsImg")
                card.setValue(UIImageJPEGRepresentation(cardToSave.frontImg, 0), forKey: "frontImg")
                card.setValue(UIImageJPEGRepresentation(cardToSave.backImg, 0), forKey: "backImg")
                card.setValue(cardToSave.back, forKey: "back")
                card.setValue(cardToSave.id, forKey: "id")
                card.setValue(cardToSave.setId, forKey: "setId")
                cardToSave.edited = false
                cardToSave.newCard = false
            } else if (cardToSave.edited) {
                let card = cards[cardToSave.id]
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
        return listOfCards.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewSetTableViewCell
        print("new cell created")
        // Get the data from Core Data
        let card = listOfCards[indexPath.row]
        cell.listItems = card
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        attatchKeyboardToolbarCards(cell.front)
        attatchKeyboardToolbarCards(cell.back)
        
        cell.card = card
        cell.nsindex = indexPath
        cell.tableView = self
        print(card.backIsImg)
        drawFront = cell.drawFront
        
        if(card.newCard) {
            cell.front.becomeFirstResponder()
        }
        
        if(cell.frontIsImg) {
            cell.frontImgView!.userInteractionEnabled = true
            let tapRecognizer = MyTapGestureRecognizer(target: self, action: "editFront:")
            tapRecognizer.cardToEdit = card
            cell.frontImgView!.addGestureRecognizer(tapRecognizer)
        }
        
        if(cell.backIsImg) {
            cell.backImgView!.userInteractionEnabled = true
            let tapRecognizer2 = MyTapGestureRecognizer(target: self, action: "editBack:")
            tapRecognizer2.cardToEdit = card
            cell.backImgView!.addGestureRecognizer(tapRecognizer2)
        }
        
        return cell
    }
    
    func attatchKeyboardToolbarName(textField : UITextField) {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let addCard = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NewSetTableViewController.addCardBtn(_:)))
        let font = UIFont(name: "Helvetica", size: 35)
        addCard.setTitleTextAttributes([NSFontAttributeName: font!], forState: UIControlState.Normal)
        addCard.tintColor = UIColor(colorLiteralRed: 228/255, green: 86/255, blue: 99/255, alpha: 1)
        toolbar.items = [flexSpace, addCard, flexSpace]
        textField.inputAccessoryView = toolbar
    }
    
    func attatchKeyboardToolbarCards(textField : UITextField) {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let addCard = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NewSetTableViewController.addCardBtn(_:)))
        let font = UIFont(name: "Helvetica", size: 35)
        addCard.setTitleTextAttributes([NSFontAttributeName: font!], forState: UIControlState.Normal)
        addCard.tintColor = UIColor(colorLiteralRed: 228/255, green: 86/255, blue: 99/255, alpha: 1)
        toolbar.items = [flexSpace, addCard, flexSpace]
        textField.inputAccessoryView = toolbar
        
        let drawCard = UIBarButtonItem(title: "Draw", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NewSetTableViewController.drawCardBtn(_:)))
        drawCard.image = UIImage(named: "draw.png")
        drawCard.setTitleTextAttributes([NSFontAttributeName: font!], forState: UIControlState.Normal)
        drawCard.tintColor = UIColor(colorLiteralRed: 228/255, green: 86/255, blue: 99/255, alpha: 1)
        toolbar.items = [flexSpace, addCard, flexSpace, drawCard]
        textField.inputAccessoryView = toolbar
    }
    
    class MyTapGestureRecognizer: UITapGestureRecognizer {
        var cardToEdit: Card?
    }
    
    @IBAction func drawCardBtn(sender: AnyObject) {
        editDrawing = false
        performSegueWithIdentifier("newDrawSegue", sender: nil)
    }
    
    func editFront(gestureRecognizer: MyTapGestureRecognizer) {
        
        let alertController = UIAlertController(title: "Edit Term", message: "", preferredStyle: .ActionSheet)
        let edit = UIAlertAction(title: "Edit Term", style: .Default, handler: { (action) -> Void in
            print("Ok Button Pressed")
            self.cardToDraw = gestureRecognizer.cardToEdit!
            self.cardToDraw.drawFront = true
            self.editDrawing = true
            self.performSegueWithIdentifier("newDrawSegue", sender: nil)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Button Pressed")
        })
        
        let  keyboard = UIAlertAction(title: "Keyboard", style: .Destructive) { (action) -> Void in
            if((gestureRecognizer.cardToEdit?.drawFront) != nil){
                print("Delete Button Pressed")
                gestureRecognizer.cardToEdit?.frontImg = UIImage()
                gestureRecognizer.cardToEdit?.frontIsImg = false
                gestureRecognizer.cardToEdit?.edited = true
                self.tableView.reloadData()
            } else {
                print("Delete Button Pressed")
                gestureRecognizer.cardToEdit?.backImg = UIImage()
                gestureRecognizer.cardToEdit?.backIsImg = false
                gestureRecognizer.cardToEdit?.edited = true
                self.tableView.reloadData()
            }
        }
        
        alertController.addAction(edit)
        alertController.addAction(cancel)
        alertController.addAction(keyboard)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func editBack(gestureRecognizer: MyTapGestureRecognizer) {
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .ActionSheet)
        let edit = UIAlertAction(title: "Edit Term", style: .Default, handler: { (action) -> Void in
            print("Ok Button Pressed")
            
            self.cardToDraw = gestureRecognizer.cardToEdit!
            self.cardToDraw.drawFront = false
            self.editDrawing = true
            self.performSegueWithIdentifier("newDrawSegue", sender: nil)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            print("Cancel Button Pressed")
        })
        
        let  keyboard = UIAlertAction(title: "Keyboard", style: .Destructive) { (action) -> Void in
            print("Delete Button Pressed")
            gestureRecognizer.cardToEdit?.backImg = UIImage()
            gestureRecognizer.cardToEdit?.backIsImg = false
            gestureRecognizer.cardToEdit?.edited = true
            self.tableView.reloadData()
        }
        
        alertController.addAction(edit)
        alertController.addAction(cancel)
        alertController.addAction(keyboard)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.destinationViewController as? MySetsTableViewController != nil{
            saveCardsSegue()
        }
        
        if let destination = segue.destinationViewController as? NewDrawViewController {
            destination.setId = setId
            destination.setName = cardSetName.text!
            print(cardSetName.text!)
            destination.listOfCards = listOfCards
            if (editDrawing) {
                destination.card = cardToDraw
                destination.drawFront = cardToDraw.drawFront
                print("Edit a drawing")
                print(destination.drawFront)
            } else {
                print("Drawing a new drawing")
                destination.card = listOfCards[(self.tableView?.indexPathForSelectedRow!.row)!]
                destination.drawFront = listOfCards[(self.tableView?.indexPathForSelectedRow!.row)!].drawFront
                destination.mainImageView = nil
            }
            print(drawFront)
        }

    }

}
