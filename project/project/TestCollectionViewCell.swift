//
//  TestCollectionViewCell.swift
//  project
//
//  Created by Paul Bass on 5/4/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {
    
    var frontString: String = ""
    var frontImage: UIImage? = nil
    var back: String = ""
    var currentSideIsFront: Bool = true
    var currentCard: Card? = nil
    var doneDrawing: Bool = false
    var correct: Bool = false
    var testController: TestSetCollectionViewController? = nil
    
    @IBOutlet weak var testCountLabel: UILabel!
    
    @IBOutlet weak var currentCardLabel: UILabel!
    @IBOutlet weak var currentCardImage: UIImageView!
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var answerImageView: UIImageView!
    
    @IBOutlet weak var textAnswerBtn: UIButton!
    @IBOutlet weak var drawAnswerBtn: UIButton!
    @IBOutlet weak var correctBtn: UIButton!
    @IBOutlet weak var wrongBtn: UIButton!
    
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
        
        if currentCard!.back == answerTextField.text {
            //Answer was correct
            self.correct = true
            self.messageLabel.numberOfLines = 0
            self.messageLabel.text = self.messageLabel.text! + "\n" + "Correct!"
        }
        else {
            //Answer was wrong
            self.correct = false
            self.messageLabel.numberOfLines = 0
            var stringHistory = [String]()
            stringHistory.append("Wrong!")
            stringHistory.append("Answer was: ")
            stringHistory.append("\(self.currentCard!.back)")
            self.messageLabel.text = stringHistory.joinWithSeparator("\n")
            //            self.messageLabel.text = self.messageLabel.text! + "\n" + "Wrong!"
            //            self.messageLabel.text = self.messageLabel.text! + "\n" + "Answer was \(self.currentCard!.back)"
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
    }
    
    @IBAction func pickCorrectBtn(sender: AnyObject) {
        self.correct = true
        self.correctBtn.hidden = true
        self.wrongBtn.hidden = true
    }
    
    @IBAction func pickWrongBtn(sender: AnyObject) {
        self.correct = false
        self.correctBtn.hidden = true
        self.wrongBtn.hidden = true
    }
    
    @IBAction func answerTextBtn(sender: AnyObject) {
        print("AnswerText clicked")
        self.checkTextAnswer()
    }

}
