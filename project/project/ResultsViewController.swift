//
//  ResultsViewController.swift
//  project
//
//  Created by Paul Bass on 5/4/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import CoreData

class ResultsViewController: UIViewController {

    var results = ""
    
    
    @IBOutlet weak var resultsLabel: UILabel!
    var setId = 0
    var selectedSet:NSManagedObject? = nil
    var setName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(false, animated: false)

        // Do any additional setup after loading the view.
        resultsLabel.text = results
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destination = segue.destinationViewController as? SetTableViewController {
            destination.setId = setId
            destination.setName = setName
            destination.selectedSet = selectedSet
        }
    }
}
