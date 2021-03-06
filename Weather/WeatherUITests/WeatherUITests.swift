//
//  WeatherUITests.swift
//  WeatherUITests
//
//  Created by Vinh Pham on 9/1/19.
//  Copyright © 2019 Vinh Pham. All rights reserved.
//

import XCTest

class WeatherUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testUIFlowAfterPressedAddPlusCities() {
        
        let app = XCUIApplication()
        app.buttons["ic plus city"].tap()
        
        let tableView = app.tables
        XCTAssertEqual(tableView.count, 1)
        XCTAssert(tableView.cells.count == 7)
        
        XCUIDevice.shared.orientation = .portrait
        XCUIApplication().buttons["ic plus city"].tap()
        
    }
}
