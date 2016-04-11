//
//  ViewController.swift
//  project
//
//  Created by Paul Bass on 3/6/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet weak var facebookLoginBtn: FBSDKLoginButton!
    var allUsers = [Dictionary<String,String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //Check if user is logged into our app with Facebook
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            print ("I am Logged in. Send me to home")
        }
        else
        {
            facebookLoginBtn.readPermissions = ["public_profile", "email", "user_friends"]
            facebookLoginBtn.delegate = self
        }
        
        //Check if user is logged into our app with Alamofire
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        // self.usernameTxtField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // MARK: FB SDK Stuff
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("public_profile")
            {
                // Do work
                self.returnUserData()
//                self.moveToHome()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        print("in return user data")
        var user = Dictionary<String, String>()
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                
                let userName : String = result.valueForKey("name") as! String
                user["username"] = userName
//                print("User Name is: \(userName)")
                
                let userEmail : String = result.valueForKey("id") as! String
//                print("User Email is: \(userEmail)")
                user["email"] = userEmail
                
                //Check if user exist in Database
                print("user Dict= ", user)
                self.getUser(user)
            }
        })
    }
    
    // MARK: User Auth
    
    func getUser(user:Dictionary<String,String>) -> Bool
    {
        var exists = false

        Alamofire.request(.GET, "https://shielded-basin-17847.herokuapp.com/contacts") .responseJSON { response in // 1
            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                self.allUsers = JSON as! [Dictionary<String,String>]
                print("JSON: \(self.allUsers)")
                for x in self.allUsers {
                    if (x["_id"] != nil) {
                        print("id= \((x["_id"])!)")
                    } else {
                        print("id= No ID")
                        print("******User Does Not Exist******")
                    }
                    if x["email"] != nil {
                        print("email= \((x["email"])!)")
                    } else {
                        print("email= No Email")
                    }
                    if x["username"] == nil {
                        print("username= No Username")
                    } else {
                        print("username= \((x["username"])!)")
                    }
                    if x["fbId"] != nil {
                        print("fbId= ", "\((x["fbId"])!)")
                        if x["fbId"] == user["email"] {
                            // User found
                            exists = true
                            print("Found!!! -", x)
                            self.moveToHome(x)
                        }
                    } else {
                        print("No Facebook Id on Record")
                    }
                }
            }
            
            print ("User exists = ", exists)
            
            //Add User info to database if not found.
            if exists == false {
                self.addUserInfo(user)
            }
        }
        return exists
    }
    
    func addUserInfo(userInfo:Dictionary<String,String>)
    {
        let parameters = [
            "username": "\((userInfo["username"])!)",
            "fbId": "\((userInfo["email"])!)"
        ]
        let headers = [
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(.POST, "https://shielded-basin-17847.herokuapp.com/contacts", headers: headers, parameters: parameters, encoding: .JSON)
        self.moveToHome(userInfo)
    }
    
    // MARK: Helpers
    
    func moveToHome (user: Dictionary<String,String>)
    {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc: MySetsTableViewController  = storyboard.instantiateViewControllerWithIdentifier("homeView") as! MySetsTableViewController
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

