//
//  Set.swift
//  project
//
//  Created by Erica Halpern on 3/21/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

class CardSet {
    
    private var _name:String = ""
    private var _id:Int = 0
    
    var name:String {
        get {
            return _name
        }
        set (newValue) {
            _name = newValue
        }
    }
    
    var id:Int {
        get {
            return _id
        }
        set (newValue) {
            _id = newValue
        }
    }
    
    init(name:String, cards:[Int], id:Int) {
        self.name = name
        self.id = id
    }
    
    convenience init() {
        self.init(name:"<NoName>", cards:[Int](), id: 0)
    }
    
    func description() -> String {
        return "name: \(name), id: \(id)"
    }
}
