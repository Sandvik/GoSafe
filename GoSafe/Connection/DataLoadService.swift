//
//  DataLoadService.swift
//  GoSafe
//
//  Created by Thomas H. Sandvik
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import Foundation

let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)

//MARK: protocol
protocol DataLoadServiceDelegate {
    func dataLoadStatus(_ status:String, methodName:String)
}

class DataLoadService: NSObject{
    var delegate: DataLoadServiceDelegate?
    
    func saveUnSafe(data: String){
        let request = APIRequest(dlg: self)
        request.remoteServer = Constants.ApiName.API_SERVER
        request.apiLoginHeader = API_DEFAULT_HEADERS
        request.requestID = Constants.ApiRequestNames.kSaveUnSafe
        request.saveUnsafe(postData: "")
    }
    
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
        if let firstSuchElement = Store.sharedInstance.registrationArray.first(where: { $0.area == registration.area }) {
            Store.sharedInstance.registrationArray = Store.sharedInstance.registrationArray.filter(){$0.area != firstSuchElement.area}
        }
        Store.sharedInstance.registrationArray.append(registration)
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            callBack(status)
        }
    }
}

//MARK: - DataLoader extension : APIRequestDelegate
extension DataLoadService : APIRequestDelegate {
    
    func request(_ req: APIRequest, finishedWithResult : AnyObject){
        print(finishedWithResult)
        if req.requestID == Constants.ApiRequestNames.kSaveUnSafe{
            // Get data - Parse Data -- Deliver the Data to eg. Store
            let parserManager: Parser = Parser()
            let status = parserManager.loadAddRegistration(serverStatus: finishedWithResult as! NSData)
            self.delegate?.dataLoadStatus(status, methodName: Constants.ApiRequestNames.kSaveUnSafe)
        }
    }
    
    func request(_ req: APIRequest, failedWithError : NSError){
        
    }
    
    func progress(_ req: APIRequest, bytesTotal: Int64, bytesRead: Int64) {
        
    }
}

