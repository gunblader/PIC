//
//  ReviewCollectionCell.swift
//  project
//
//  Created by Christopher Komplin on 4/4/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit

class ReviewCollectionCell: UICollectionViewCell {
    
    var front: String = ""
    var back: String = ""
    var currentSideIsFront: Bool = true
    
    @IBOutlet weak var label: UILabel!
    
    func tapped() {
        if currentSideIsFront {
            label.text = back
        }
        else {
            label.text = front
        }
        currentSideIsFront = !currentSideIsFront
    }
    
}