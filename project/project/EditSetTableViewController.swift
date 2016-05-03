//
//  EditSetTableViewController.swift
//  project
//
//  Created by Erica Halpern on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import Cloudinary

class EditSetTableViewController: UITableViewController, UITextFieldDelegate, CLUploaderDelegate {
    var cloudinary: CLCloudinary = CLCloudinary()
    var cards = [NSManagedObject]()

    let reuseIdentifier = "cardEditId"
    var setName =  ""
    var setId = -1
    var set:NSManagedObject? = nil
    var listOfCards = [Card]()
    let idCounter = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var setNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Cloudinary Setup
        cloudinary.config().setValue("hslxltk00", forKey: "cloud_name")
        cloudinary.config().setValue("673259648684198", forKey: "api_key")
        cloudinary.config().setValue("4lBQQNfcDASoO9qNoV0R_c7kZV4", forKey: "api_secret")
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.title = "Edit Set"
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! EditSetTableViewCell
        
        let card = listOfCards[indexPath.row]
        cell.listItems = card
        cell.selectionStyle = UITableViewCellSelectionStyle.Blue
        attatchKeyboardToolbar(cell.front)
        attatchKeyboardToolbar(cell.back)
        cell.front.userInteractionEnabled = false
        if(card.newCard) {
            cell.front.becomeFirstResponder()
        }
        cell.front.userInteractionEnabled = true
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
    
    // MARK: - Image Storage
    
    func uploadToCloudinary(fileId:String){
        let image = UIImage(named: "turtle.jpg")
        let forUpload = UIImagePNGRepresentation(image!)! as NSData
        let uploader = CLUploader(cloudinary, delegate: self)
        
        uploader.upload(forUpload, options: ["public_id":fileId],
                        withCompletion:onCloudinaryCompletion, andProgress:onCloudinaryProgress)
        
    }
    
    func uploadDetailsToServer(fileId:String){
        //upload your metadata to your rest endpoint
        print("send to server \(fileId)")
    }
    
    func onCloudinaryCompletion(successResult:[NSObject : AnyObject]!, errorResult:String!, code:Int, idContext:AnyObject!) {
        let fileId = successResult["public_id"] as! String
        print("Response \(successResult)")
        uploadDetailsToServer(fileId)
        
    }
    
    func onCloudinaryProgress(bytesWritten:Int, totalBytesWritten:Int, totalBytesExpectedToWrite:Int, idContext:AnyObject!) {
        //do any progress update you may need
    }
    
    @IBAction func addPIC(sender: AnyObject) {
        print ("save image")
        uploadToCloudinary("turtle")
        
        
//        self.sendImage()
//        let URL = "https://shielded-basin-17847.herokuapp.com/upload"
    }
    
    // MARK: - Segue
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? SetTableViewController {
            destination.setName = setNameTextField.text!
            destination.setId = setId
            self.view.endEditing(true)
            
            saveNewCards()
        }
        navigationController?.setToolbarHidden(true, animated: false)
    }
}
