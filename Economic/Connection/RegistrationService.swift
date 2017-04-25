//
//  RegistrationService.swift
//  Economic
//
//  Created by Thomas H. Sandvik on 20/04/2017.
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import Foundation

let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)

class RegistrationService {
    
    //the service delivers mocked data with a delay
    func getRegistrations(_ callBack:@escaping (String) -> Void){
        /**
         TODO: Call service that GET all Registrations
         */
        let parserManager: Parser = Parser()
        let status = parserManager.loadRegistrations(registrations: NSData()) // NSDATA() is abstraction for data from server
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            callBack(status)
        }
    }
    
    //the service delivers mocked data with a delay
    func getInvoices(_ callBack:@escaping (String) -> Void){
        /**
         TODO: Call service that GET all invoices
         */
        let parserManager: Parser = Parser()
        let status = parserManager.loadInvoices(invoices: NSData()) // NSDATA() is abstraction for data from server
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            callBack(status)
        }
    }
    
    //the service sets data with a delay
    func setRegistration(registration: Registration, _ callBack:@escaping (String) -> Void){
        
        /**
         TODO: Call service that ADD new Registration
         */
        let parserManager: Parser = Parser()
        let status = parserManager.loadAddRegistration(serverStatus: NSData()) // NSDATA() is abstraction for data from server
        
        /**
         REMOVE:
         I put values in Store to illuminate that the service is called later
        */
        if let firstSuchElement = Store.sharedInstance.registrationArray.first(where: { $0.projectName == registration.projectName }) {
            Store.sharedInstance.registrationArray = Store.sharedInstance.registrationArray.filter(){$0.projectName != firstSuchElement.projectName}
        }
        Store.sharedInstance.registrationArray.append(registration)
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            callBack(status)
        }
    }
}
