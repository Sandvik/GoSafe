//
//  Store.swift
//  Economic
//
//  Created by Thomas H. Sandvik on 19/04/2017.
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import Foundation


class Store {
    static let sharedInstance: Store = Store()
    
    var registrationArray = [Registration]()
    var invoicesArray = [Invoice]()
    
    private init() {
        self.registrationArray = []
        self.invoicesArray = []
    }    
}
