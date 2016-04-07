//
//  EditSetListItem.swift
//  project
//
//  Created by Erica Halpern on 3/28/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import CoreData

class NewSetListItem: NSObject {
    var card: Card
    var front: String
    var back: String
    var id: Int
    var newCard: Bool
    
    init(front: String, back: String, id:Int, card: Card, newCard: Bool) {
        self.front = front
        self.back = back
        self.id = id
        self.card = card
        self.newCard = false
    }
}