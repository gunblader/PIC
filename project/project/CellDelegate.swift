//
//  CellDelegate.swift
//  project
//
//  Created by Erica Halpern on 5/3/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import Foundation

protocol CellDelegate {
    func callSegueFromCell(myData dataobject: AnyObject)
}