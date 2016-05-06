//
//  PracticeController.swift
//  project
//
//  Created by Christopher Komplin on 5/4/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

import UIKit
import CoreData

class PracticeController: UICollectionViewController, UITextFieldDelegate {
    
    var cards = [Card]()
    let reuseIdentifier = "PracticeCell"
    var setName =  ""
    var testSetCount = 0
    var correctCount = 0
    var wrongCount = 0
    var cardAnswers = [UIImage?]()
    var returningFromDraw: Bool = false
    var indexDrawing = 0
    let leftHandModeDef = NSUserDefaults.standardUserDefaults()
    var leftHandMode = false
    var imgToSave:UIImage? = nil
    
    
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
        else {
            for _ in cards {
                cardAnswers.append(nil)
            }
        }
        
        leftHandMode = (leftHandModeDef.objectForKey("lefty") as? Bool)!

        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        let path: NSIndexPath = NSIndexPath(forRow: indexDrawing, inSection: 0)
        self.collectionView?.scrollToItemAtIndexPath(path, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: false)
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
        return cards.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PracticeCell
        let index:Int = indexPath.row
        let card = self.cards[index]
        cell.currentCard = card
        cell.controller = self
        cell.index = index
        cell.practiceView = self
        cell.cardAnswers = self.cardAnswers
        cell.answerTextField.delegate = cell
        
        // Set the cell to display the info
        
        if card.frontIsImg {
            cell.currentCardImage.image = card.frontImg
            cell.currentCardLabel.text = ""
        } else {
            cell.currentCardLabel.text = card.front
        }
        if self.returningFromDraw && index == indexDrawing {
            //configure cell for Returned Draw Answer
            cell.answerTextField.hidden = true
            cell.drawAnswerBtn.hidden = true

            cell.answerImageView.hidden = false
            cell.answerImageView.image = self.imgToSave
            cell.tapForAnswer.hidden = true
            
            if (leftHandMode) {
                cell.redrawBtnLeft.hidden = false
                cell.redrawBtn.hidden = true
            } else {
                cell.redrawBtnLeft.hidden = true
                cell.redrawBtn.hidden = false
            }
        }
            
        else if self.returningFromDraw && cardAnswers[index] != nil{
            cell.answerTextField.hidden = true
            cell.drawAnswerBtn.hidden = true
            cell.answerImageView.hidden = false
            cell.answerImageView.image = cardAnswers[index]
            cell.tapForAnswer.hidden = true
            
            if (leftHandMode) {
                cell.redrawBtnLeft.hidden = false
                cell.redrawBtn.hidden = true
            } else {
                cell.redrawBtnLeft.hidden = true
                cell.redrawBtn.hidden = false
            }
        }
        
        else if card.backIsImg {
            //configure cell for Draw Answer
            cell.answerTextField.hidden = true
            cell.tapForAnswer.hidden = true
            cell.drawAnswerBtn.hidden = false
            cell.redrawBtn.hidden = true
            cell.redrawBtnLeft.hidden = true

        } else {
            //configure cell for Text Answer
            cell.drawAnswerBtn.hidden = true
            cell.redrawBtn.hidden = true
            cell.redrawBtnLeft.hidden = true
            cell.answerImageView.hidden = true
            cell.answerTextField.hidden = false
            cell.tapForAnswer.hidden = false
        }
//        cell.testCountLabel.text = "\(self.testSetCount + 1)/\(self.cards.count)"
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor(red:0.87, green:0.91, blue:0.96, alpha:1.0).CGColor
        
        return cell
    }
    
    //    function to implement for touch events
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PracticeCell
                cell.tapped()
    }
    
    func backFromDraw(testSetCount:Int, correct:Int, wrong:Int){
        self.testSetCount = testSetCount
        self.correctCount = correct
        self.wrongCount = wrong
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("draw seg")
        if let destination = segue.destinationViewController as? PracticeDrawViewController {
            print("segue to draw")
            destination.cards = self.cards
            destination.setName = self.setName
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
