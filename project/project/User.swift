//
//  user.swift
//  project
//
//  Created by Erica Halpern on 3/21/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

class User {
    
    private var _firstName:String = ""
    private var _lastName:String = ""
    private var _email:String = ""
    private var _id:Int = 0
    
    var firstName:String {
        get {
            return _firstName
        }
        set (newValue) {
            _firstName = newValue
        }
    }
    var lastName:String {
        get {
            return _lastName
        }
        set (newValue) {
            _lastName = newValue
        }
    }
    var email:String {
        get {
            return _email
        }
        set (newValue) {
            _email = newValue
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
    
    init(firstName:String, lastName:String, email:String, id:Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.id = id
    }
    
    convenience init() {
        self.init(firstName:"<NoName>", lastName:"<NoName>", email:"<NoEmail>", id: 0)
    }
    
    func description() -> String {
        return "FirstName: \(firstName), LastName: \(lastName), email: \(email), id: \(id)"
    }
}
