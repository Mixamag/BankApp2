//
//  Model.swift
//  BankApp
//
//  Created by Mikhail Gorbunov on 25.06.2024.
//

import UIKit
import RealmSwift

var model: Model?

class Model: Object {
    @objc dynamic var timeAndDate: String = ""
    @objc dynamic var operation: String = ""
    @objc dynamic var target: String = ""
    @objc dynamic var sum: Float = 0.0
    @objc dynamic var type: String = ""
}

class Balance: Object {
    @objc dynamic var amount: Float = 0.0
}

