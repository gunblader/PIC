//
//  EditSetTableViewCell.swift
//  project
//
//  Created by Erica Halpern on 3/28/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import CoreData

class EditSetTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var front: UITextField!
    @IBOutlet weak var back: UITextField!
    
    var cardSet:CardSet = CardSet()
    
    var newCard:Bool = false
    var id: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
      
    var listItems:EditSetListItem? {
        didSet {
            front.text = listItems!.front
            back.text = listItems!.back
            newCard = listItems!.newCard
        }
    }
    
    func saveCard(cardToSave: NSManagedObject) {
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

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // 1
        front = UITextField(frame: CGRect.null)
        back = UITextField(frame: CGRect.null)

        front.textColor = UIColor.blackColor()
        back.textColor = UIColor.blackColor()

        front.font = UIFont.systemFontOfSize(16)
        back.font = UIFont.systemFontOfSize(16)

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 2
        front.delegate = self
        back.delegate = self

        front.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        back.contentVerticalAlignment = UIControlContentVerticalAlignment.Center

        // 3
        addSubview(front)
        addSubview(back)
        
        front.placeholder = "Front"
        back.placeholder = "Back"
    }
    
    let leftMarginForLabel: CGFloat = 15.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        front.frame = CGRect(x: leftMarginForLabel, y: 0, width: bounds.size.width - leftMarginForLabel, height: bounds.size.height)
        back.frame = CGRect(x: leftMarginForLabel + 100, y: 0, width: bounds.size.width - leftMarginForLabel, height: bounds.size.height)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if listItems != nil {
            listItems?.front = textField.text!
            listItems?.back = textField.text!
            
            listItems?.card.setValue(front.text, forKey: "front")
            listItems?.card.setValue(back.text, forKey: "back")
        }
        return true
    }
    
    
}