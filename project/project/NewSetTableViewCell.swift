//
//  NewSetTableViewCell.swift
//  project
//
//  Created by Erica Halpern on 4/6/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import CoreData

class NewSetTableViewCell: UITableViewCell, UITextFieldDelegate {
    
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
        if (frontIsImg){
            frontImgView?.hidden = false
            front.hidden = true
        } else {
            front.hidden = false
            frontImgView?.hidden = true
        }
        
        if (backIsImg){
            backImgView?.hidden = false
            back.hidden = true
        } else {
            back.hidden = false
            backImgView?.hidden = true
        }
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
        front = UITextField(frame: CGRect.null)
        back = UITextField(frame: CGRect.null)
        frontImgView = UIImageView(frame: CGRect.null)
        backImgView = UIImageView(frame: CGRect.null)
        
        
        front.textColor = UIColor.blackColor()
        back.textColor = UIColor.blackColor()
        
        front.font = UIFont.systemFontOfSize(16)
        back.font = UIFont.systemFontOfSize(16)
        
        frontImgView?.contentMode = UIViewContentMode.ScaleAspectFit
        backImgView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        frontImgView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        frontImgView?.layer.borderWidth = 0.5
        backImgView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        backImgView?.layer.borderWidth = 0.5
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        front.delegate = self
        back.delegate = self
        
        front.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        back.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        
        addSubview(front)
        addSubview(back)
        addSubview(frontImgView!)
        addSubview(backImgView!)
        
        front.placeholder = "Front"
        back.placeholder = "Back"
    }
    
    let leftMarginForLabel: CGFloat = 20.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imgSize = bounds.size.height - leftMarginForLabel
        
        front.frame = CGRect(x: leftMarginForLabel, y: 0, width: bounds.size.width - leftMarginForLabel, height: bounds.size.height)
        frontImgView!.frame = CGRect(x: leftMarginForLabel, y: leftMarginForLabel/2, width: bounds.size.width/2 - leftMarginForLabel*2, height: imgSize)
        
        
        back.frame = CGRect(x: leftMarginForLabel + bounds.size.width/2, y: 0, width: bounds.size.width - leftMarginForLabel, height: bounds.size.height)
        backImgView!.frame = CGRect(x: leftMarginForLabel + bounds.size.width/2, y: leftMarginForLabel/2, width: bounds.size.width/2 - leftMarginForLabel*2, height: imgSize)
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
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