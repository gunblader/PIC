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

    var frontImgView: UIImageView?
    var backImgView: UIImageView?

    var cardSet:CardSet = CardSet()
    var card:Card = Card()
    var addImg = false
    
    var newCard:Bool = false

    var tableView:UITableViewController? = nil
    var nsindex: NSIndexPath? = nil
    var frontIsImg = false
    var frontImg = UIImage()
    var backIsImg = false
    var backImg = UIImage()
    var drawFront = true
    
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
      
    var listItems:Card? {
        didSet {
            front.text = listItems!.front
            back.text = listItems!.back
            frontIsImg = listItems!.frontIsImg
            frontImg = listItems!.frontImg
            frontImgView?.image = frontImg
            backIsImg = listItems!.backIsImg
            backImg = listItems!.backImg
            backImgView?.image = backImg
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // 1
        front = UITextField(frame: CGRect.null)
        back = UITextField(frame: CGRect.null)
        frontImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 90))
        backImgView = UIImageView(frame: CGRect(x: 50, y: 0, width: 100, height: 90))

        
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
        addSubview(frontImgView!)
        addSubview(backImgView!)

        front.placeholder = "Front"
        back.placeholder = "Back"
    }
    
    let leftMarginForLabel: CGFloat = 15.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bounds.size.width/2
        front.frame = CGRect(x: leftMarginForLabel, y: 0, width: bounds.size.width - leftMarginForLabel, height: bounds.size.height)
        back.frame = CGRect(x: leftMarginForLabel + 200, y: 0, width: bounds.size.width - leftMarginForLabel, height: bounds.size.height)
        frontImgView!.frame = CGRect(x: leftMarginForLabel, y: 0, width: bounds.size.width - leftMarginForLabel, height: bounds.size.height)
        backImgView!.frame =  CGRect(x: leftMarginForLabel + 200, y: 0, width: bounds.size.width - leftMarginForLabel, height: bounds.size.height)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        tableView!.tableView.selectRowAtIndexPath(nsindex, animated: true, scrollPosition: UITableViewScrollPosition.None)

        if(front.isFirstResponder()){
            card.drawFront = true
        }
        if(back.isFirstResponder()){
            card.drawFront = false
        }
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if listItems != nil {
            listItems?.front = front.text!
            listItems?.back = back.text!
            card.front = front.text!
            card.back = back.text!
            listItems?.edited = true
        }
        
        if(front.isFirstResponder()){
            card.drawFront = true
        }
        if(back.isFirstResponder()){
            card.drawFront = false
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    
}