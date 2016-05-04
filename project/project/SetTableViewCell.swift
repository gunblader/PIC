//
//  SetTableViewCell.swift
//  project
//
//  Created by Erica Halpern on 4/19/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class SetTableViewCell: UITableViewCell, UITextFieldDelegate {

//    @IBOutlet weak var frontLabel: UILabel!
//    @IBOutlet weak var backLabel: UILabel!
//    @IBOutlet weak var frontImg: UIImageView!
//    @IBOutlet weak var backImg: UIImageView!
    
    
    @IBOutlet weak var front: UITextField!
    @IBOutlet weak var back: UITextField!
    
    var frontImgView: UIImageView?
    var backImgView: UIImageView?
    
    var card:Card = Card()
    
    var frontIsImg = false
    var frontImg = UIImage()
    var backIsImg = false
    var backImg = UIImage()
    
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
        // 1
        front = UITextField(frame: CGRect.null)
        back = UITextField(frame: CGRect.null)
        frontImgView = UIImageView(frame: CGRect.null)
        backImgView = UIImageView(frame: CGRect.null)
        
        front.userInteractionEnabled = false
        back.userInteractionEnabled = false

        front.textColor = UIColor.blackColor()
        back.textColor = UIColor.blackColor()
        
        front.font = UIFont.systemFontOfSize(16)
        back.font = UIFont.systemFontOfSize(16)
        
        frontImgView?.contentMode = UIViewContentMode.ScaleAspectFit
        backImgView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 2
        front.delegate = self
        back.delegate = self
        
        front.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        back.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        
        
        frontImgView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        frontImgView?.layer.borderWidth = 0.5
        backImgView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        backImgView?.layer.borderWidth = 0.5

        // 3
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
}
