//
//  ObserveUser.swift
//  GoSafe
//
//  Created by Thomas H. Sandvik
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import UIKit

class ObserveUser {
    var gender:String
    var age:Int
    var locationZip:Int
    
    init(gender: String, age:Int,locationZip:Int) {
        self.gender = gender
        self.age = age
        self.locationZip = locationZip
    }
}
