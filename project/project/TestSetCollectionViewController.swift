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

class TestSetCollectionViewController: UICollectionViewController, UITextFieldDelegate {
    
    var cards = [Card]()
    let reuseIdentifier = "testCollection"
    var setName =  ""
    var testSetCount = 0
    var correctCount = 0
    var wrongCount = 0
    var returnedDrawImage:UIImage? = nil
    var returningFromDraw: Bool = false
    var setId = 0
    var selectedSet:NSManagedObject? = nil
    var correct = 0
    var wrong = 0
    
    
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
        cell.answerTextField.delegate = cell
        
        // Set the cell to display the info
        
        if card.frontIsImg {
            cell.currentCardImage.hidden = false
            cell.currentCardLabel.text = ""
            cell.currentCardImage.image = card.frontImg
        } else {
            cell.currentCardLabel.hidden = false
            cell.currentCardLabel.text = card.front
            cell.currentCardImage.hidden = true
        }
        if self.returningFromDraw {
            //configure cell for Returned Draw Answer
            self.returningFromDraw = false
            cell.answerTextField.hidden = true
            cell.messageLabel.hidden = true
            cell.textAnswerBtn.hidden = true
            cell.drawAnswerBtn.hidden = true
            cell.nextBtn.hidden = true
            cell.answerImageView.hidden = false
            cell.currentCardLabel.hidden = true
            cell.currentCardImage.hidden = false
            cell.currentCardImage.image = card.backImg
            cell.answerImageView.image = self.returnedDrawImage
            cell.messageLabel.text = ""
            cell.correctBtn.hidden = false
            cell.wrongBtn.hidden = false
            
        } else if card.backIsImg {
            //configure cell for Draw Answer
            cell.answerTextField.hidden = true
            cell.messageLabel.hidden = true
            cell.textAnswerBtn.hidden = true
            cell.correctBtn.hidden = true
            cell.wrongBtn.hidden = true
            cell.drawAnswerBtn.hidden = false
            
        } else {
            //configure cell for Text Answer
            cell.drawAnswerBtn.hidden = true
            cell.answerImageView.hidden = true
            cell.messageLabel.text = ""
            cell.textAnswerBtn.hidden = false
            cell.answerTextField.hidden = false
            cell.correctBtn.hidden = true
            cell.wrongBtn.hidden = true
        }
        self.title = "\(self.testSetCount + 1)/\(self.cards.count)"
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
        print("step")
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
            self.showResults()
        }
        
    }
    
    func showResults() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc: ResultsViewController  = storyboard.instantiateViewControllerWithIdentifier("resultsView") as! ResultsViewController
        
        vc.results = "\(self.correctCount)/\(self.cards.count)"
        vc.setName = setName
        vc.setId = setId
        vc.selectedSet = selectedSet
        self.navigationController?.pushViewController(vc, animated: true)
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
            
            destination.setId = setId
            destination.setName = setName
            destination.set = selectedSet
        }
        
        if let destination = segue.destinationViewController as? DrawViewController {
            destination.setId = setId
            destination.setName = setName
            destination.set = selectedSet
        }
        
        navigationController?.setToolbarHidden(true, animated: false)
    }

    
}
