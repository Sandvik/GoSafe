//
//  UIView.swift
//  Economic
//
//  Created by Thomas H. Sandvik on 15/04/2017.
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//
import UIKit

extension UIView {
    
    //http://mookid.dk/oncode/archives/3780
    func applyPlainShadow() {
        let layer = self.layer        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 2
    }
}
