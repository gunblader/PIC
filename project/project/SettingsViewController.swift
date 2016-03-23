//
//  SettingsViewController.swift
//  project
//
//  Created by Paul Bass on 3/23/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBOutlet weak var redColorChange: UIButton!

    
    @IBOutlet weak var privateAccountSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editProfileBtn(sender: AnyObject) {
    }

    @IBAction func logoutBtn(sender: AnyObject) {
    }
    
    @IBAction func privateAccountBtn(sender: AnyObject) {
    }
    
    @IBAction func redColorChangeBtn(sender: AnyObject) {
    }
    
    @IBAction func greenColorChangeBtn(sender: AnyObject) {
    }
    
    @IBAction func blackColorChangeBtn(sender: AnyObject) {
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
