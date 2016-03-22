//
//  Card.swift
//  project
//
//  Created by Erica Halpern on 3/21/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

class Card {
    
    private var _front:String = ""
    private var _back:String = ""
    private var _id:Int = 0
    private var _setId:Int = 0

    var front:String {
        get {
            return _front
        }
        set (newValue) {
            _front = newValue
        }
    }
    
    var back:String {
        get {
            return _back
        }
        set (newValue) {
            _back = newValue
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
    
    var setId:Int {
        get {
            return _setId
        }
        set (newValue) {
            _setId = newValue
        }
    }
    
    init(front:String, back:String, id:Int, setId:Int) {
        self.front = front
        self.back = back
        self.id = id
        self.setId = setId
    }
    
    convenience init() {
        self.init(front:"<NoFront>", back:"<NoBack>", id: 0, setId: 0)
    }
    
    func description() -> String {
        return "front: \(front),  back: \(back), id: \(id), setId: \(setId)"
    }
}