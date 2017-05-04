//
//  GoSafeTests.swift
//  GoSafeTests
//
//  Created by Thomas H. Sandvik on 04/05/2017.
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import XCTest

class GoSafeTests: XCTestCase {
    
    class RegistrationServiceMock: RegistrationService {
        fileprivate let registrations: [Registration]
        init(registrations: [Registration]) {
            self.registrations = registrations
        }
        override func getRegistrations(_ callBack: @escaping ([Registration]) -> Void) {
            callBack(registrations)
        }
        
    }
    
    class RegistrationViewMock : NSObject, RegistrationView{
        var setRegistrationsCalled = false
        var setEmptyRegistrationsCalled = false
        
        func setRegistrations(_ registrations: [RegistrationViewData]) {
            setRegistrationsCalled = true
        }
        
        func setEmptyRegistrations() {
            setEmptyRegistrationsCalled = true
        }
        
        func startLoading() {
        }
        
        func finishLoading() {
        }
        
    }
    
    class RegistrationPresenterTest: XCTestCase {
        
        let emptyRegistrationsServiceMock = RegistrationServiceMock(registrations:[Registration]())
        
        let towRegistrationsServiceMock = RegistrationServiceMock(registrations:[Registration(firstName: "firstname1", lastName: "lastname1", email: "first@test.com", age: 30),
                                                                                 Registration(firstName: "firstname2", lastName: "lastname2", email: "second@test.com", age: 24)])
        override func setUp() {
            super.setUp()
            // Put setup code here. This method is called before the invocation of each test method in the class.
        }
        
        override func tearDown() {
            // Put teardown code here. This method is called after the invocation of each test method in the class.
            super.tearDown()
        }
        
        func testShouldSetEmptyIfNoRegistrationsAvailable() {
            //given
            let registrationViewMock = RegistrationViewMock()
            let registrationPresenterUnderTest = RegistrationPresenter(registrationService: emptyRegistrationsServiceMock)
            registrationPresenterUnderTest.attachView(registrationViewMock)
            
            //when
            registrationPresenterUnderTest.getRegistrations()
            
            //verify
            XCTAssertTrue(registrationViewMock.setEmptyRegistrationsCalled)
        }
        
        func testShouldSetRegistrations() {
            //given
            let registrationsViewMock = RegistrationViewMock()
            let registrationsPresenterUnderTest = RegistrationPresenter(registrationService: towRegistrationsServiceMock)
            registrationsPresenterUnderTest.attachView(registrationsViewMock)
            
            //when
            registrationsPresenterUnderTest.getRegistrations()
            
            //verify
            XCTAssertTrue(registrationsViewMock.setRegistrationsCalled)
        }
    
}
}
