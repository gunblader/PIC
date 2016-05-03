//
//  SetTableViewCell.swift
//  project
//
//  Created by Erica Halpern on 4/19/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class SetTableViewCell: UITableViewCell {

    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var frontImg: UIImageView!
    @IBOutlet weak var backLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
