//
//  SettingsViewController.swift
//  project
//
//  Created by Paul Bass on 3/23/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var redColorChange: UIButton!


    @IBOutlet weak var leftHandModeSwitch: UISwitch!
    
    @IBOutlet weak var privateAccountSwitch: UISwitch!
    
    let leftHandMode = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftHandModeSwitch.on =  (leftHandMode.objectForKey("lefty") as? Bool)!
        print("vdl: \(leftHandModeSwitch.on)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    
//    @IBAction func saveSettings(sender: AnyObject) {
//        leftHandMode.setObject(leftHandModeSwitch.on, forKey:"lefty")
//        print("sv: \(leftHandModeSwitch.on)")
//    }
    @IBAction func editProfileBtn(sender: AnyObject) {
    }

    @IBAction func logoutBtn(sender: AnyObject) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    @IBAction func privateAccountBtn(sender: AnyObject) {
    }
    
    @IBAction func redColorChangeBtn(sender: AnyObject) {
        
        // change tint color of navigation bar items
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        
        // change tint color of navigation bar background
        UINavigationBar.appearance().barTintColor = UIColor.redColor()
    }
    
    @IBAction func greenColorChangeBtn(sender: AnyObject) {
        
        // change tint color of navigation bar items
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        
        // change tint color of navigation bar background
        UINavigationBar.appearance().barTintColor = UIColor.greenColor()
    }
    
    @IBAction func blackColorChangeBtn(sender: AnyObject) {
        
        // change tint color of navigation bar items
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        
        // change tint color of navigation bar background
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor() 
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        leftHandMode.setObject(leftHandModeSwitch.on, forKey:"lefty")

        print("sg: \(leftHandModeSwitch.on)")

    }

}
