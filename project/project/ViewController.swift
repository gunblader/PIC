//
//  ViewController.swift
//  project
//
//  Created by Paul Bass on 3/6/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        self.usernameTxtField.resignFirstResponder()
        self.passwordTxtField.resignFirstResponder()
        return true
    }

    @IBAction func loginBtn(sender: AnyObject) {
    }

    @IBAction func createAccountBtn(sender: AnyObject) {
    }
}

