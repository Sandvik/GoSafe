//
//  Store.swift
//  GoSafe
//
//  Created by Thomas H. Sandvik
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
