//
//  TestCollectionViewCell.swift
//  project
//
//  Created by Paul Bass on 5/4/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    var frontString: String = ""
    var frontImage: UIImage? = nil
    var back: String = ""
    var currentSideIsFront: Bool = true
    var currentCard: Card? = nil
    var doneDrawing: Bool = false
    var correct: Bool = false
    var testController: TestSetCollectionViewController? = nil
    
    @IBOutlet weak var currentCardLabel: UILabel!
    @IBOutlet weak var currentCardImage: UIImageView!
    
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var answerImageView: UIImageView!
    
    @IBOutlet weak var textAnswerBtn: UIButton!
    @IBOutlet weak var drawAnswerBtn: UIButton!
    
    @IBOutlet weak var correctBtn: UIButton!
    @IBOutlet weak var wrongBtn: UIButton!

    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    

    //    func tapped() {
    //        if currentSideIsFront {
    //            currentCardLabel.text = back
    //        }
    //        else {
    //            currentCardLabel.text = front
    //        }
    //        currentSideIsFront = !currentSideIsFront
    //    }
    
    func checkTextAnswer() {
        print("check")
        if currentCard!.back == answerTextField.text {
            //Answer was correct
            self.correct = true
            self.messageLabel.hidden = false
            self.textAnswerBtn.hidden = true
            self.messageLabel.numberOfLines = 0
            self.messageLabel.text = self.messageLabel.text! + "\n" + "Correct!"
        }
        else {
            //Answer was wrong
            self.correct = false
            self.messageLabel.hidden = false
            self.messageLabel.numberOfLines = 0
            var stringHistory = [String]()
            stringHistory.append("Wrong!")
            stringHistory.append("Answer was: ")
            stringHistory.append("\(self.currentCard!.back)")
            self.messageLabel.text = stringHistory.joinWithSeparator("\n")
            self.textAnswerBtn.hidden = true
        }
        currentSideIsFront = !currentSideIsFront
    }
    
    @IBAction func nextQuestionBtn(sender: AnyObject) {
        print("next clicked")
        self.messageLabel.text = ""
        self.answerTextField.text = ""
        self.testController?.testStep(self.correct)
    }
    
    @IBAction func answerDrawBtn(sender: AnyObject) {
        print("Draw clicked")
        self.draw()
    }
    
    @IBAction func pickCorrectBtn(sender: AnyObject) {
        self.correct = true
        self.correctBtn.hidden = true
        self.wrongBtn.hidden = true
        self.answerImageView.hidden = true
        self.testController?.testStep(self.correct)
    }
    
    @IBAction func pickWrongBtn(sender: AnyObject) {
        self.correct = false
        self.correctBtn.hidden = true
        self.wrongBtn.hidden = true
        self.answerImageView.hidden = true
        self.testController?.testStep(self.correct)
    }
    
    @IBAction func answerTextBtn(sender: AnyObject) {
        print("AnswerText clicked")
        self.checkTextAnswer()
    }

    func draw() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc: TestDrawViewController  = storyboard.instantiateViewControllerWithIdentifier("testDraw") as! TestDrawViewController
        
        vc.cards = self.testController!.cards
        vc.setName = self.testController!.setName
        vc.testSetCount = self.testController!.testSetCount
        vc.correct = self.testController!.correctCount
        vc.wrong = self.testController!.wrongCount
        
        self.testController!.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
 
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

}
