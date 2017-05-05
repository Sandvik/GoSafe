//
//  UIView.swift
//  GoSafe
//
//  Created by Thomas H. Sandvik
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//
import UIKit
import pop

extension UIView {
    
    //http://mookid.dk/oncode/archives/3780
    func applyPlainShadow() {
        let layer = self.layer        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 2
    }
    
    func jumpBtn(_ jump1:CGFloat, jump2:CGFloat) {
        let sprintAnimation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        sprintAnimation.toValue = NSValue(cgPoint: CGPoint(x: 1, y: 1))
        sprintAnimation.velocity = NSValue(cgPoint: CGPoint(x: jump1, y: jump2))
        sprintAnimation.springBounciness = 20.0
        self.pop_add(sprintAnimation, forKey: "springAnimation")
    }
    
    /**
     Fade in a view with a duration
     - parameter duration: custom animation duration
     */
    func fadeIn(duration: TimeInterval = animationSpeed, value: CGFloat){
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            // put here the code you would like to animate
            self.alpha = value
        }, completion: {(finished:Bool) in
            // the code you put here will be compiled once the animation finishes
        })
    }
    
    /**
     Fade out a view with a duration and remove view
     - parameter duration: custom animation duration
     */
    func fadeOutAndRemove(duration: TimeInterval = animationSpeed) {
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            // put here the code you would like to animate
            self.alpha = 0.0
        }, completion: {(finished:Bool) in
            // the code you put here will be compiled once the animation finishes
            self.removeFromSuperview()
        })
    }
    
    /**
     Fade out a view with a duration and remove view
     - parameter duration: custom animation duration
     */
    func fadeOut(duration: TimeInterval = animationSpeed) {
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            // put here the code you would like to animate
            self.alpha = 0.0
        }, completion: {(finished:Bool) in
            // the code you put here will be compiled once the animation finishes
            
        })
    }
}
