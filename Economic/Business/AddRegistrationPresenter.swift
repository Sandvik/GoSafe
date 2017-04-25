//
//  AddRegistrationPresenter.swift
//  Economic
//
//  Created by Thomas H. Sandvik on 19/04/2017.
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import Foundation

/*
 We need an abstraction of the view, which can be used in the presenter without knowing about UIViewController. We do that by defining a protocol RegistrationView:
 */
protocol AddRegistrationView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setStatus(status: String)
    func setEmptyRegistrations()
}

class AddRegistrationPresenter {
    
    fileprivate let registrationService:RegistrationService
    
    weak fileprivate var addRegistrationView : AddRegistrationView? //avoid retain cycle
    
    init(registrationService:RegistrationService){
        self.registrationService = registrationService
    }
    
    func attachView(_ view:AddRegistrationView){
        addRegistrationView = view
    }
    
    func detachView() {
        addRegistrationView = nil
    }    
    
    func setRegistration(registrationViewData: RegistrationViewData){
        self.addRegistrationView?.startLoading()
        let registrationData: Registration = Registration(firstName: registrationViewData.name, lastName: "", email: "", minutesSpend: (Int)(registrationViewData.minutesSpend)!, projectName: registrationViewData.projectName)
        
        registrationService.setRegistration(registration: registrationData){ [weak self] status in
            
            self?.addRegistrationView?.finishLoading()            
            self?.addRegistrationView?.setStatus(status: status)
        }
    }
}
