//
//  EditSetListItem.swift
//  project
//
//  Created by Erica Halpern on 3/28/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import CoreData

class EditSetListItem: NSObject {
    var card: NSManagedObject
    var front: String
    var back: String
    var id: Int
    var newCard: Bool

    init(front: String, back: String, id:Int, card: NSManagedObject, newCard: Bool) {
        self.front = front
        self.back = back
        self.id = id
        self.card = card
        self.newCard = false
    }
}