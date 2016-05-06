//
//  PracticeCell.swift
//  project
//
//  Created by Christopher Komplin on 5/4/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class PracticeCell: UICollectionViewCell, UITextFieldDelegate {
    
    var currentSideIsFront: Bool = true
    var currentCard: Card? = nil
    var doneDrawing: Bool = false
    var controller: PracticeController? = nil
    var cardAnswers = [UIImage?]()
    
//    @IBOutlet weak var testCountLabel: UILabel!
    
    @IBOutlet weak var currentCardLabel: UILabel!
    @IBOutlet weak var currentCardImage: UIImageView!
    
    @IBOutlet weak var tapForAnswer: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var answerImageView: UIImageView!
    
//    @IBOutlet weak var textAnswerBtn: UIButton!
    
    @IBOutlet weak var redrawBtnLeft: UIButton!
    @IBOutlet weak var redrawBtn: UIButton!
    @IBOutlet weak var drawAnswerBtn: UIButton!
//    @IBOutlet weak var correctBtn: UIButton!
//    @IBOutlet weak var wrongBtn: UIButton!
    
    
    var practiceView:PracticeController? = nil
    var index: Int = 0
    
        func tapped() {
            if currentSideIsFront {
                if currentCard!.backIsImg {
                    currentCardImage.image = currentCard?.backImg
                    currentCardLabel.text = ""
                }
                else {
                    currentCardLabel.text = currentCard!.back
                    currentCardImage.image = nil
                }
            }
            else {
                if currentCard!.frontIsImg {
                    currentCardImage.image = currentCard?.frontImg
                    currentCardLabel.text = ""
                }
                else {
                    currentCardLabel.text = currentCard!.front
                    currentCardImage.image = nil
                }
            }
            currentSideIsFront = !currentSideIsFront
        }
    @IBAction func drawBtn(sender: AnyObject) {
        print("tapped")
        draw()
    }
    
//    func checkTextAnswer() {
//        
//        if currentCard!.back.lowercaseString == answerTextField.text?.lowercaseString  {
//            //Answer was correct
//            self.messageLabel.numberOfLines = 0
//            self.messageLabel.text = self.messageLabel.text! + "\n" + "Correct!"
//        }
//        else {
//            //Answer was wrong
//            self.messageLabel.numberOfLines = 0
//            var stringHistory = [String]()
//            stringHistory.append("Wrong!")
//            stringHistory.append("Answer was: ")
//            stringHistory.append("\(self.currentCard!.back)")
//            self.messageLabel.text = stringHistory.joinWithSeparator("\n")
//            //            self.messageLabel.text = self.messageLabel.text! + "\n" + "Wrong!"
//            //            self.messageLabel.text = self.messageLabel.text! + "\n" + "Answer was \(self.currentCard!.back)"
//        }
//        currentSideIsFront = !currentSideIsFront
//    }
    
    func draw() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc: PracticeDrawViewController  = storyboard.instantiateViewControllerWithIdentifier("practiceDraw") as! PracticeDrawViewController

        vc.cards = practiceView!.cards
        vc.setName = practiceView!.setName
        vc.indexDrawingAt = self.index
        vc.cardAnswers = self.cardAnswers
        
        self.practiceView!.navigationController?.pushViewController(vc, animated: true)
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
