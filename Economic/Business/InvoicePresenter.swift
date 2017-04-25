//
//  InvoicePresenterPresenter.swift
//  Economic
//
//  Created by Thomas H. Sandvik on 11/04/2017.
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import Foundation
/*
 We need an abstraction of the view, which can be used in the presenter without knowing about UIViewController. We do that by defining a protocol InvoiceView:
 */
protocol InvoiceView: NSObjectProtocol {
    func startLoading()
    func finishLoading()
    func setInvoices(_ invoices: [InvoiceViewData])
    func setEmptyInvoices()
}

class InvoicePresenter {
    
    fileprivate let registrationService:RegistrationService
    weak fileprivate var invoiceView : InvoiceView? //avoid retain cycle
    
    init(registrationService:RegistrationService){
        self.registrationService = registrationService
    }
    
    func attachView(_ view:InvoiceView){
        invoiceView = view
    }
    
    func detachView() {
        invoiceView = nil
    }
    
    func getInvoices(){
        self.invoiceView?.startLoading()
        registrationService.getInvoices{ [weak self] status in
            self?.invoiceView?.finishLoading()
            if status == "OK"{
                if(Store.sharedInstance.invoicesArray.count == 0){
                    self?.invoiceView?.setEmptyInvoices()
                }
                else{
                    let mappedRegistrations: [InvoiceViewData] = Store.sharedInstance.invoicesArray.map{
                        return InvoiceViewData(name: "\($0.firstName) \($0.lastName)", minutesSpend: "\($0.minutesSpend)", projectName: $0.projectName)
                    }                    
                    
                    self?.invoiceView?.setInvoices(mappedRegistrations)
                }
            }
            else{
                self?.invoiceView?.setEmptyInvoices()
            }
        }
    }
}
