//
//  DrawViewController.swift
//  project
//
//  Created by Erica Halpern on 5/2/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import CoreData

class NewDrawViewController: UIViewController {
    var brush: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var setName =  ""
    var setId = -1
    var set:NSManagedObject? = nil
    var listOfCards = [Card]()
    var drawFront = true
    var card = Card()
    
    var testSetCount = 0
    var correct = 0
    var wrong = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.interactivePopGestureRecognizer?.enabled = false
        print(navigationController?.navigationBar.backItem?.backBarButtonItem?.action.description)
        
        // If editing an image, load it
        if(drawFront && card.frontIsImg) {
            mainImageView.image = card.frontImg
        } else if(!drawFront && card.backIsImg) {
            print("draw back")
            mainImageView.image = card.backImg
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    var lastPoint = CGPoint.zero
    var brushWidth: CGFloat = 5
    var swiped = false
    
    //(102.0 / 255.0, 204.0 / 255.0, 0), //green
    
    
    // MARK: - Actions
    
    @IBAction func reset(sender: AnyObject) {
        mainImageView.image = nil
    }
    
    func saveDrawing() {
        print("SAVING")
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0,
            width: mainImageView.frame.size.width, height: mainImageView.frame.size.height - (self.navigationController?.toolbar.frame.size.height)!))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        card.edited = true
        if(drawFront) {
            card.frontImg = image
            card.frontIsImg = true
        } else {
            card.backImg = image
            card.backIsImg = true
        }
        
    }
    
    @IBAction func blackBtn(sender: AnyObject) {
        brushWidth = 5.0
        red = 0.0
        green = 0.0
        blue = 0.0
    }
    @IBAction func redBtn(sender: AnyObject) {
        brushWidth = 5.0
        red = 1.0
        green = 0.0
        blue = 0.0
    }
    @IBAction func greenBtn(sender: AnyObject) {
        brushWidth = 5.0
        red = 102.0 / 255.0
        green = 204.0 / 255.0
        blue = 0.0
    }
    
    @IBAction func blueBtn(sender: AnyObject) {
        brushWidth = 5.0
        red = 0.0
        green = 0.0
        blue = 1.0
    }
    
    @IBAction func eraseBtn(sender: AnyObject) {
        brushWidth = 50.0
        red = 1.0
        green = 1.0
        blue = 1.0
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        if let touch = touches.first{
            lastPoint = touch.locationInView(self.view)
            let frameH = view.frame.size.height
            let navH = (self.navigationController?.toolbar.frame.size.height)!
            let newH = frameH - navH
            lastPoint.y += lastPoint.y - (lastPoint.y/frameH) * newH;
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        // 4
        CGContextStrokePath(context)
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 6
        swiped = true
        
        if let touch = touches.first {
            var currentPoint = touch.locationInView(view)
            let frameH = view.frame.size.height
            let navH = (self.navigationController?.toolbar.frame.size.height)!
            let newH = frameH - navH
            currentPoint.y += currentPoint.y - (currentPoint.y/frameH) * newH;
            
            
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - (self.navigationController?.toolbar.frame.size.height)!), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - (self.navigationController?.toolbar.frame.size.height)!), blendMode: CGBlendMode.Normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let destination = segue.destinationViewController as? NewSetTableViewController {
            print("to set create")
            destination.returningFromDraw = true
            if segue.identifier == "saveNewSetDrawSegue" {
                self.saveDrawing()
            }
            
            UIGraphicsBeginImageContext(mainImageView.bounds.size)
            mainImageView.image?.drawInRect(CGRect(x: 0, y: 0,
                width: mainImageView.frame.size.width, height: mainImageView.frame.size.height - (self.navigationController?.toolbar.frame.size.height)!))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            destination.imgToSave = image
            
            print(setName)
            
            destination.setId = setId
            destination.setName = setName
            destination.listOfCards = listOfCards
        }
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
