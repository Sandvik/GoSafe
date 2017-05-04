//
//  MainViewController.swift
//  GoSafe
//
//  Created by Thomas H. Sandvik
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import UIKit

/*
 Using an external Framework to create a menu: https://github.com/HongliYu/DPSlideMenuKit-Swift
 But have not used it as POD because I would customize it beyond what it allowed
 */
class MainViewController: UIViewController {
    
    @IBOutlet weak var drawerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the drawer
        var drawer: DPDrawerViewController?
        self.childViewControllers.forEach { (viewController) in
            if viewController is DPDrawerViewController {
                drawer = viewController as? DPDrawerViewController
            }
        }
        
        // Set basis controller
        let homeViewController: MapViewController? = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        
        // Create menuItem for every view controller
        let slideMenuMap: DPSlideMenuModel = DPSlideMenuModel(
            color: UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
            ,
            controllerClassName: "MapViewController",
            title: NSLocalizedString("Kort", comment: ""),
            cellHeight: 50,
            actionBlock: nil)
        
        let slideMenuRegistrations: DPSlideMenuModel = DPSlideMenuModel(
            color: UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
            ,
            controllerClassName: "RegistrationViewController",
            title: NSLocalizedString("Registreringer", comment: ""),
            cellHeight: 50,
            actionBlock: nil)
        let slideMenuInvoices: DPSlideMenuModel = DPSlideMenuModel(
            color: UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
            ,
            controllerClassName: "InvoicesViewController",
            title: NSLocalizedString("osv, osv", comment: ""),
            cellHeight: 50,
            actionBlock: nil)
        
        
        
        let slideMenuModels: [DPSlideMenuModel] = [slideMenuMap,slideMenuRegistrations,slideMenuInvoices]
        
        // Create leftMenuViewController with menu-array, then reset the drawer
        let leftMenuViewController: DPLeftMenuViewController = DPLeftMenuViewController(slideMenuModels: slideMenuModels, storyboard: self.storyboard)
        drawer?.reset(leftViewController: leftMenuViewController,
                      centerViewController: homeViewController)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

