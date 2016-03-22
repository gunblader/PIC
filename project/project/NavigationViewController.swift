//
//  NavigationViewController.swift
//  project
//
//  Created by Erica Halpern on 3/21/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Status bar white font


        // Do any additional setup after loading the view.
        

        let navigationBar = self.navigationBar
        
        let navBorder: UIView = UIView(frame: CGRectMake(0, navigationBar.frame.size.height - 1, navigationBar.frame.size.width, 1))
        // Set the color you want here
        navBorder.backgroundColor = UIColor(red:0.92, green:0.43, blue:0.46, alpha:1.0)
        navBorder.opaque = true
        navigationBar.addSubview(navBorder)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
