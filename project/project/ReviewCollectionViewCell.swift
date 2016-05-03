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
    var frontImg: UIImage = UIImage()
    var backImg: UIImage = UIImage()
    var frontIsImg: Bool = false
    var backIsImg: Bool = false

    var currentSideIsFront: Bool = true
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func tapped() {
        if currentSideIsFront {
            if backIsImg {
                imgView.hidden = false
                imgView.image = backImg
                label.text = ""
            } else {
                label.text = back
                imgView.hidden = true
            }
        }
        else {
            if frontIsImg {
                imgView.hidden = false
                imgView.image = frontImg
                label.text = ""
            } else {
                label.text = front
                imgView.hidden = true
            }
        }
        currentSideIsFront = !currentSideIsFront
    }
}