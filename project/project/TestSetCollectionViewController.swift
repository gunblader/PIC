//
//  TestSetCollectionViewController.swift
//  project
//
//  Created by Paul Bass on 5/4/16.
//  Copyright © 2016 cs378. All rights reserved.
//
import Foundation

import UIKit
import CoreData

class TestSetCollectionViewController: UICollectionViewController {
    
    var cards = [Card]()
    let reuseIdentifier = "testCollection"
    var setName =  ""
    var testSetCount = 0
    var correctCount = 0
    var wrongCount = 0
    var returnedDrawImage:UIImage? = nil
    var returningFromDraw: Bool = false
    
    
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
        //        testSetCount = cards.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("im done")
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TestCollectionViewCell
        
        let card = cards[testSetCount]
        cell.currentCard = card
        cell.testController = self
        
        // Set the cell to display the info
        
        if card.frontIsImg {
            cell.currentCardImage.image = card.frontImg
        } else {
            cell.currentCardLabel.text = card.front
        }
        if self.returningFromDraw {
            //configure cell for Returned Draw Answer
            cell.answerTextField.hidden = true
            cell.answerLabel.hidden = true
            cell.messageLabel.hidden = true
            cell.textAnswerBtn.hidden = true
            cell.drawAnswerBtn.hidden = true
            cell.answerImageView.hidden = true
            cell.messageLabel.text = ""
            
        } else if !card.backIsImg {
            //configure cell for Draw Answer
            cell.answerTextField.hidden = true
            cell.answerLabel.hidden = true
            cell.messageLabel.hidden = true
            cell.textAnswerBtn.hidden = true
            
        } else {
            //configure cell for Text Answer
            cell.drawAnswerBtn.hidden = true
            cell.answerImageView.hidden = true
            cell.messageLabel.text = ""
        }
        cell.testCountLabel.text = "\(self.testSetCount + 1)/\(self.cards.count)"
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor(red:0.87, green:0.91, blue:0.96, alpha:1.0).CGColor
        
        return cell
    }
    
    //    function to implement for touch events
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! TestCollectionViewCell
        //        cell.tapped()
        
    }
    
    func backFromDraw(testSetCount:Int, correct:Int, wrong:Int){
        self.testSetCount = testSetCount
        self.correctCount = correct
        self.wrongCount = wrong
    }
    
    func testStep (score:Bool){
        if (self.testSetCount + 1) != cards.count {
            self.testSetCount += 1
            if score {
                self.correctCount += 1
            } else {
                self.wrongCount += 1
            }
            self.collectionView?.reloadData()
            
        } else {
            // Segue to Results View Controller
            print("done with test")
        }
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("draw seg")
        if let destination = segue.destinationViewController as? DrawViewController {
            print("segue to draw")
            destination.testSetCount = self.testSetCount
            destination.correct = self.correctCount
            destination.wrong = self.wrongCount
            self.view.endEditing(true)
        }
        if let destination = segue.destinationViewController as? TestSetCollectionViewController {
            print("return to test mode")
            destination.returningFromDraw = true
            
//            UIGraphicsBeginImageContext(mainImageView.bounds.size)
//            mainImageView.image?.drawInRect(CGRect(x: 0, y: 0,
//                width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            destination.returnedDrawImage = image
            
            print(image)
            
            destination.testSetCount = self.testSetCount
            destination.setName = setName
//            destination.correctCount = self.correct
//            destination.wrongCount = self.wrong
        }
        navigationController?.setToolbarHidden(true, animated: false)
    }

    
}
