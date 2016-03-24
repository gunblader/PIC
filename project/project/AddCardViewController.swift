//
//  AddCardViewController.swift
//  project
//
//  Created by Erica Halpern on 3/22/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import CoreData

class AddCardViewController: UIViewController {
    var cards = [NSManagedObject]()
    var setName = ""
    
    @IBOutlet weak var front: UITextField!
    @IBOutlet weak var back: UITextField!
    
    @IBOutlet weak var savedLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Turn navbar back on
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveBtn(sender: AnyObject) {
        let card:Card = Card(front: front.text!, back: back.text!, id: 1, setId: 1)
        self.saveCard(card)
        view.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        self.front.resignFirstResponder()
        self.back.resignFirstResponder()
        return true
    }
    
    func saveCard(cardToSave:Card) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // Create the entity we want to save
        let entity =  NSEntityDescription.entityForName("Card", inManagedObjectContext: managedContext)
        
        let card = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        // Set the attribute values
        card.setValue(cardToSave.front, forKey: "front")
        card.setValue(cardToSave.back, forKey: "back")
        card.setValue(1, forKey: "id")
        
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
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destinationViewController as? EditSetTableViewController {
            destination.setName = setName
        }
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

}
