//
//  GitPatchUITests.swift
//  GitPatchUITests
//
//  Created by Rolland Cédric on 04.12.17.
//  Copyright © 2017 Rolland Cédric. All rights reserved.
//

import XCTest

class GitPatchUITests: XCTestCase {
    
    var app:XCUIApplication? = nil
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        app = XCUIApplication()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testInfinitScrollUser() {
        guard let app = app else {
            XCTFail()
            return
        }
        
        let usersTable = app.tables["usersTable"]
        XCTAssertNotNil(usersTable)
        usersTable.swipeUp()
        usersTable.swipeUp()
        usersTable.swipeUp()
    }
    
    func testUserDetails() {
        guard let app = app else {
            XCTFail()
            return
        }
        
        let usersTable = app.tables["usersTable"]
        XCTAssertNotNil(usersTable)
        usersTable.cells.staticTexts["mojombo"].tap()
        
        let userDetailsTable = app.tables["userDetailsTable"]
        XCTAssertNotNil(userDetailsTable)
        
        let userDetailCell = userDetailsTable.cells.staticTexts["Stars"]
        XCTAssertNotNil(userDetailCell)
        
        let reposDetailCell = userDetailsTable.cells.staticTexts["tokuda109"]
        XCTAssertNotNil(reposDetailCell)
        
        
    }
}
