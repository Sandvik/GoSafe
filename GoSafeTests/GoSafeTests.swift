//
//  GoSafeTests.swift
//  GoSafeTests
//
//  Created by Thomas H. Sandvik on 04/05/2017.
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import XCTest
@testable import GoSafe

class GoSafeTests: XCTestCase {
    
    class RegistrationServiceMock: DataLoadService {
        fileprivate let registrations: [Registration]
        init(registrations: [Registration]) {
            self.registrations = registrations
        }
        
        func getRegistrations(_ callBack: @escaping ([Registration]) -> Void) {
            callBack(registrations)
        }
    }
    
    class RegistrationViewMock : NSObject, RegistrationView{
        var setRegistrationsCalled = false
        var setEmptyRegistrationsCalled = false
        
        func setRegistrations(_ registrations: [RegistrationViewData]) {
            setRegistrationsCalled = true
        }
        
        func setEmptyRegistrations(){
        }
        
        func startLoading() {
        }
        
        func finishLoading() {
        }
        
    }
    
    class RegistrationPresenterTest: XCTestCase {
        
        let emptyRegistrationsServiceMock = RegistrationServiceMock(registrations:[Registration]())
        
        let towRegistrationsServiceMock = RegistrationServiceMock(registrations:[Registration(firstName: "firstname1", lastName: "lastname1", email: "first@test.com", minutesSpend: 30, area: ""),
                                                                                 Registration(firstName: "firstname2", lastName: "lastname2", email: "second@test.com", minutesSpend: 24, area: "test")])
        override func setUp() {
            super.setUp()
            // Put setup code here. This method is called before the invocation of each test method in the class.
        }
        
        override func tearDown() {
            // Put teardown code here. This method is called after the invocation of each test method in the class.
            super.tearDown()
        }
        
        func testShouldSetRegistrations() {
            //given
            let registrationsViewMock = RegistrationViewMock()
            let registrationsPresenterUnderTest = RegistrationPresenter(DataLoadService: towRegistrationsServiceMock)
            registrationsPresenterUnderTest.attachView(registrationsViewMock)
            
            //when
            registrationsPresenterUnderTest.getRegistrations()
            
            //verify
            XCTAssertTrue(registrationsViewMock.setRegistrationsCalled)
        }        
    }
}
