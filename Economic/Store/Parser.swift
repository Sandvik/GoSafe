//
//  Parser.swift
//  Economic
//
//  Created by Thomas H. Sandvik on 19/04/2017.
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import Foundation

protocol ParserDelegate {
    func parseStatus(status:String)
}

class Parser{
    var delegate: ParserDelegate?
    
    init (dlg: ParserDelegate) {
        self.delegate = dlg
    }
    
    init(){
    }
    
    // Fetch serverdata and translate into model object
    func loadRegistrations(registrations :NSData) -> String{
        var status: String = "OK"  // Mocked
        // Just as an illustration
        do {
            
            let json = try JSONSerialization.jsonObject(with: registrations as Data, options: []) as! [String: AnyObject]
            print(json)
            status = "OK"
        }
            
        catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            status = "Error"
        }
        
        // Mocked Data / should be from json
        let registrations = [Registration(firstName: "Iyad", lastName: "Agha", email: "iyad@test.com", minutesSpend: 356, projectName: "project1"),
                             Registration(firstName: "Mila", lastName: "Haward", email: "mila@test.om", minutesSpend: 244, projectName: "project2"),
                             Registration(firstName: "Mark", lastName: "Astun", email: "mark@test.com", minutesSpend: 394, projectName: "project3")
        ]
        // Put values in Store
        if Store.sharedInstance.registrationArray.count < registrations.count{
            /**
             REMOVE:
             I only do this to have data in Store after user has added an registration -- Should not be done live
             */
            
            Store.sharedInstance.registrationArray = registrations
        }
        
        status = "OK"
        
        return status
    }
    
    // Fetch serverdata and translate into model object
    func loadInvoices(invoices :NSData) -> String{
        var status: String = "OK"  // Mocked
        // Just as an illustration
        do {
            
            let json = try JSONSerialization.jsonObject(with: invoices as Data, options: []) as! [String: AnyObject]
            print(json)
            status = "OK"
        }
            
        catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            status = "Error"
        }
        
        /**
         TODO: Mocked Data / should be from json
         */
        let invoices = [Invoice(firstName: "Iyad", lastName: "Agha", email: "iyad@test.com", minutesSpend: 356, projectName: "project1"),
                        Invoice(firstName: "Mila", lastName: "Haward", email: "mila@test.om", minutesSpend: 244, projectName: "project2"),
                        Invoice(firstName: "Mark", lastName: "Astun", email: "mark@test.com", minutesSpend: 394, projectName: "project3")
        ]
        // Put values in Store
        if Store.sharedInstance.invoicesArray.count < invoices.count{
            /**
             REMOVE:
             I only do this to have data in Store after user has added an registration -- Should not be done live
             */
            Store.sharedInstance.invoicesArray = invoices
        }
        
        status = "OK"
        
        return status
    }
    
    // Fetch serverdata and translate
    func loadAddRegistration(serverStatus :NSData) -> String{
        var status: String = "OK"  // Mocked
        
        /**
         REMOVE:
         Just as an illustration
         */
        do {
            let json = try JSONSerialization.jsonObject(with: serverStatus as Data, options: []) as! [String: AnyObject]
            status = json["status"] as! String
        }
            
        catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            status = "Error"
        }
        
        return status
    }
}
