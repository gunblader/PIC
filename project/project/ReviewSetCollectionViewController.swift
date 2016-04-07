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
    
    private let sectionInsets = UIEdgeInsets(top: 25.0, left: 10.0, bottom: 25.0, right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        // Set the cell to display the info
        cell.front = self.cards[index].valueForKey("front") as! String
        cell.back = self.cards[index].valueForKey("back") as! String
        cell.label.text = cell.front
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor(red:0.87, green:0.91, blue:0.96, alpha:1.0).CGColor
        return cell
    }
    
    //    function to implement for touch events
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ReviewCollectionCell
        cell.tapped()
        
        
    }
    
    //    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
    //        let cell = collectionView.cellForItemAtIndexPath(indexPath)
    //        cell?.backgroundColor = UIColor.redColor()
    //    }
    //
    //    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
    //        let cell = collectionView.cellForItemAtIndexPath(indexPath)
    //            cell!.backgroundColor = UIColor.greenColor()
    //    }
    
    
}