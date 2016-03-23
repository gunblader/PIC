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
    private var _date:String = ""
    private var _id:Int = 0
    
    var name:String {
        get {
            return _name
        }
        set (newValue) {
            _name = newValue
        }
    }
    
    var date:String {
        get {
            return _date
        }
        set (newValue) {
            _date = newValue
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
    
    init(name:String, date:String, id:Int) {
        self.name = name
        self.date = date
        self.id = id
    }
    
    convenience init() {
        self.init(name:"<NoName>", date:"<NoDate>", id: 0)
    }
    
    func description() -> String {
        return "name: \(name), date: \(date) id: \(id)"
    }
}
