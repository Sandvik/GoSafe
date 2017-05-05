//
//  RegistrationPresenter.swift
//  GoSafe
//
//  Created by Thomas H. Sandvik
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import Foundation
/*
 We need an abstraction of the view, which can be used in the presenter without knowing about UIViewController. We do that by defining a protocol RegistrationView:
 */
protocol RegistrationView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setRegistrations(_ registrations: [RegistrationViewData])
    func setEmptyRegistrations()
}

class RegistrationPresenter {
    
    fileprivate let DataLoadService:DataLoadService
    weak fileprivate var registrationView : RegistrationView? //avoid retain cycle
    
    init(DataLoadService:DataLoadService){
        self.DataLoadService = DataLoadService
    }
    
    func attachView(_ view:RegistrationView){
        registrationView = view
    }
    
    func detachView() {
        registrationView = nil
    }
    
    func getRegistrations(){
        self.registrationView?.startLoading()
        DataLoadService.getRegistrations{ [weak self] status in
            self?.registrationView?.finishLoading()
            if status == "OK"{
                if(Store.sharedInstance.registrationArray.count == 0){
                    self?.registrationView?.setEmptyRegistrations()
                }
                else{
                    let mappedRegistrations: [RegistrationViewData] = Store.sharedInstance.registrationArray.map{
                        return RegistrationViewData(name: "\($0.firstName) \($0.lastName)", minutesSpend: "\($0.minutesSpend)", area: $0.area)
                    }                    
                    
                    self?.registrationView?.setRegistrations(mappedRegistrations)
                }
            }
            else{
                self?.registrationView?.setEmptyRegistrations()
            }
        }
    }
}
