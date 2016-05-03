//
//  ReviewSetCollectionViewController.swift
//  project
//
//  Created by Christopher Komplin on 4/4/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

import UIKit
import CoreData

class ReviewSetCollectionViewController: UICollectionViewController {
    
    var cards = [NSManagedObject]()
    let reuseIdentifier = "reviewCollection"
    var setName =  ""
    
    @IBOutlet weak var noCardsLabel: UILabel!
    
    private let sectionInsets = UIEdgeInsets(top: 25.0, left: 10.0, bottom: 25.0, right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(cards.count == 0) {
            let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
            label.center = CGPointMake(160, 284)
            label.textAlignment = NSTextAlignment.Center
            label.text = "No cards to display."
            self.view.addSubview(label)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cards.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ReviewCollectionCell
        
        let index:Int = indexPath.row
        
        var card = self.cards[index]
        // Set the cell to display the info
        cell.front = card.valueForKey("front") as! String
        cell.back = card.valueForKey("back") as! String
        cell.frontImg = UIImage()
        cell.frontIsImg = card.valueForKey("frontIsImg") as! Bool
        cell.backIsImg = card.valueForKey("backIsImg") as! Bool
        cell.backImg = UIImage()
        
        if(cell.frontIsImg) {
            cell.imgView.hidden = false
            cell.frontImg = UIImage(data: card.valueForKey("frontImg") as! NSData)!
            cell.imgView.image = cell.frontImg
            cell.label.text = ""
        } else {
            cell.imgView.hidden = true
            cell.label.text = cell.front
        }
        
        if(cell.backIsImg) {
            cell.backImg = UIImage(data: card.valueForKey("backImg") as! NSData)!
        }
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor(red:0.87, green:0.91, blue:0.96, alpha:1.0).CGColor
        return cell
    }
    
    //    function to implement for touch events
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ReviewCollectionCell
        cell.tapped()
        
        
    }
}