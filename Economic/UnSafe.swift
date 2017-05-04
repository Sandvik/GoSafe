//
//  UnSafe.swift
//  GoSafe
//
//  Created by Thomas H. Sandvik
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import UIKit

class UnSafe {
    var latitude:Double
    var longitude:Double
    var id:Int
    var spottedDate:Date
    var confirmed:Int
    var observedBy:ObserveUser
    
    init(latitude: Double, longitude:Double,spottedDate:Date,confirmed:Int,observedBy:ObserveUser) {
        self.latitude = latitude
        self.longitude = longitude
        self.spottedDate = spottedDate
        self.confirmed = confirmed
        self.observedBy = observedBy
        self.id = 0
    }
}
