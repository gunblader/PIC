//
//  Card.swift
//  project
//
//  Created by Erica Halpern on 3/21/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation
import UIKit

class Card {
    
    private var _front:String = ""
    private var _back:String = ""
    private var _frontImg:UIImage = UIImage()
    private var _backImg:UIImage = UIImage()
    private var _frontIsImg:Bool = false
    private var _backIsImg:Bool = false
    private var _id:Int = 0
    private var _setId:Int = 0
    private var _edited:Bool = false
    private var _newCard:Bool = true
    private var _drawFront:Bool = true

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
    
    var frontImg:UIImage {
        get {
            return _frontImg
        }
        set (newValue) {
            _frontImg = newValue
        }
    }
    
    var backImg:UIImage {
        get {
            return _backImg
        }
        set (newValue) {
            _backImg = newValue
        }
    }
    
    var frontIsImg:Bool {
        get {
            return _frontIsImg
        }
        set (newValue) {
            _frontIsImg = newValue
        }
    }
    
    var backIsImg:Bool {
        get {
            return _backIsImg
        }
        set (newValue) {
            _backIsImg = newValue
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
    
    var drawFront:Bool {
        get {
            return _drawFront
        }
        set (newValue) {
            _drawFront = newValue
        }
    }
    
    init(front:String, back:String, frontIsImg:Bool, backIsImg:Bool,frontImg:UIImage, backImg:UIImage, id:Int, setId:Int, edited:Bool, newCard:Bool, drawFront:Bool) {
        self.front = front
        self.back = back
        self.frontImg = frontImg
        self.backImg = backImg
        self.frontIsImg = frontIsImg
        self.backIsImg = backIsImg
        self.id = id
        self.setId = setId
        self.edited = false
        self.newCard = false
        self.drawFront = true
    }
    
    convenience init() {
        self.init(front:"<NoFront>", back:"<NoBack>", frontIsImg:false, backIsImg:false, frontImg:UIImage(), backImg:UIImage(),id: 0, setId: 0, edited: false, newCard: false, drawFront: true)
    }
    
    func description() -> String {
        return "front: \(front),  back: \(back), id: \(id), setId: \(setId)"
    }
}