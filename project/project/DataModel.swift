//
//  DataModel.swift
//  project
//
//  Created by Erica Halpern on 3/21/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

class DataModel {
    
    private var list:[Card] = [Card]()
    
    init() {
        // Create the list of people
        list.append(Card(front: "hi", back: "bye", id: 0, setId: 0))
    }
    
    func count() -> Int {
        return list.count
    }
    
    func get(index index:Int) -> Card {
        if index < list.count {
            return list[index]
        } else {
            return Card(front: "bad", back: "bad", id: 0, setId: 0)
        }
    }
    
    func add(Card card:Card) {
        list.append(card)
    }
    
    func delete(index index:Int) {
        if index < list.count {
            list.removeAtIndex(index)
        }
    }
}