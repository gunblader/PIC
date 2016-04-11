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
    private var _edited:Bool = false
    private var _newCard:Bool = true

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
    
    var edited:Bool {
        get {
            return _edited
        }
        set (newValue) {
            _edited = newValue
        }
    }
    
    var newCard:Bool {
        get {
            return _newCard
        }
        set (newValue) {
            _newCard = newValue
        }
    }
    
    init(front:String, back:String, id:Int, setId:Int, edited:Bool, newCard:Bool) {
        self.front = front
        self.back = back
        self.id = id
        self.setId = setId
        self.edited = false
        self.newCard = false
    }
    
    convenience init() {
        self.init(front:"<NoFront>", back:"<NoBack>", id: 0, setId: 0, edited: false, newCard: false)
    }
    
    func description() -> String {
        return "front: \(front),  back: \(back), id: \(id), setId: \(setId)"
    }
}